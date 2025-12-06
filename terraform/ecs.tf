
locals {
  list_of_private_app_subnets = values(aws_subnet.private_app_subnet)[*].id
  list_of_private_db_subnets  = values(aws_subnet.private_db_subnet)[*].id
}

# ECS CLUSTER
resource "aws_ecs_cluster" "blog_cluster" {
  name = var.ecs_cluster_name
}

# IAM ROLES

# ECS Task Execution Role used by ECS Agents (pull images, fetch secrets, write logs to cloud watch, pull ssm params, etc)
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.ecs_cluster_name}-execution-role"
  assume_role_policy = file("${path.module}/ecs_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_policy" "ecs_task_execution_secrets_policy" {
  name = "ecsTaskExecutionSecretsPolicy"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret"
        ]
        Resource = aws_secretsmanager_secret.db_credentials.arn
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach_secrets" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_secrets_policy.arn
}


# ECS Task Role used by the Task (read secrets from Secrets Manager, any other api calls made by the app)
resource "aws_iam_role" "ecs_task_role" {
  name               = "${var.ecs_cluster_name}-task-role"
  assume_role_policy = file("${path.module}/ecs_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_secrets_attach" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}


# EC2 INSTANCE ROLE FOR ECS
resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.ecs_cluster_name}-ec2-role"
  assume_role_policy = file("${path.module}/ecs_instance_role.json")
}

resource "aws_iam_role_policy_attachment" "ecs_instance_attach_ecs" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_role_policy_attachment" "ecs_instance_attach_ssm" {
  role       = aws_iam_role.ecs_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# IAM INSTANCE PROFILE FOR ECS EC2 INSTANCES
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.ecs_cluster_name}-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}

# LAUNCH TEMPLATE (PRIVATE SUBNET ECS INSTANCES)

data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.ecs_cluster_name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.app_ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.ecs_host_sg.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.blog_cluster.name} >> /etc/ecs/ecs.config
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ecs_cluster_name}-instance"
    }
  }
}


# AUTO SCALING GROUP (ECS EC2 HOSTS)
resource "aws_autoscaling_group" "ecs_asg" {
  name                = "${var.ecs_cluster_name}-asg"
  desired_capacity    = var.desired_capacity
  max_size            = var.max_size
  min_size            = var.min_size
  vpc_zone_identifier = local.list_of_private_app_subnets
  health_check_type   = "EC2"

  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_name}-ecs-ec2"
    propagate_at_launch = true
  }
}

# ECS CAPACITY PROVIDER
resource "aws_ecs_capacity_provider" "ecs_cp" {
  name = "${var.ecs_cluster_name}-cp"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_asg.arn
    managed_termination_protection = "DISABLED"

    managed_scaling {
      maximum_scaling_step_size = 5
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 80
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cp_link" {
  cluster_name       = aws_ecs_cluster.blog_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.ecs_cp.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.ecs_cp.name
    weight            = 1
  }
}

# CLOUDWATCH LOG GROUP (FOR TASK)
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.ecs_task_family}"
  retention_in_days = 30
}

# ECS TASK DEFINITION (awsvpc mode)
resource "aws_ecs_task_definition" "flask_task" {
  family                   = var.ecs_task_family
  network_mode             = "awsvpc"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn      = aws_iam_role.ecs_task_role.arn

  container_definitions = jsonencode([
    {
      name      = "flask"
      image     = "${aws_ecr_repository.blog_repo.repository_url}:latest"
      essential = true

      portMappings = [{
        containerPort = var.app_port
        protocol      = "tcp"
      }]

      secrets = [
        {
          name      = "DB_USER"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:username"
        },
        {
          name      = "DB_PASS"
          valueFrom = "${aws_secretsmanager_secret.db_credentials.arn}:password"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.app_logs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}


# ECS SERVICE (REGISTER TASKS TO ALB)

resource "aws_ecs_service" "flask_service" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.blog_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  launch_type     = "EC2"
  desired_count   = var.service_desired_count

  network_configuration {
    subnets         = local.list_of_private_app_subnets
    security_groups = [aws_security_group.app_sg.id]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.app_tg.arn
    container_name   = "flask"
    container_port   = var.app_port
  }

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener.https
  ]
}
