# ECS Cluster -> Cotains EC2 Instances running ECS Agent
resource "aws_ecs_cluster" "blog_cluster" {
  name = var.ecs_cluster_name
}

# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_instance_role" {
  name = "${var.ecs_cluster_name}-ec2-role"

  # EC2 Instance Role Trust Policy
  assume_role_policy = file("${path.module}/ecs_instance_role.json")
}

# Attach AmazonEC2ContainerServiceforEC2Role Policy to ECS Instance Role
resource "aws_iam_role_policy_attachment" "ecs_instance_attach" {
  role = aws_iam_role.ecs_instance_role.name

  # AmazonEC2ContainerServiceforEC2Role -> registers EC2, send updates related to the instance status, health, cpu/memory utilization, deregister instances etc.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}


# IAM Instance Profile for ECS Instances -> A wrapper around an IAM role that allows EC2 instances to obtain temporary security credentials
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "${var.ecs_cluster_name}-instance-profile"
  role = aws_iam_role.ecs_instance_role.name
}


# Get the latest Amazon ECS-Optimized AMI
data "aws_ami" "ecs_optimized" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }

  owners = ["amazon"]
}

# Define Launch Template for ECS EC2 Instances
resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.ecs_cluster_name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.app_ec2_instance_type


  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.app_sg.id]
  }

  # User Data to configure ECS Agent to connect to the correct ECS Cluster upon instance launch
  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.blog_cluster.name} >> /etc/ecs/ecs.config
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ecs_cluster_name}-ec2"
    }
  }
}

# ECS Task Definition for Flask Application
resource "aws_ecs_task_definition" "flask_task" {
  # Family -> Task versioning
  family                   = var.ecs_task_family
  network_mode             = "bridge"
  requires_compatibilities = ["EC2"]
  cpu                      = var.task_cpu
  memory                   = var.task_memory
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "flask-app"
      image     = "${aws_ecr_repository.blog_repo.repository_url}:latest"
      essential = true
      portMappings = [
        {
          containerPort = var.app_port
          hostPort      = var.app_port
        }
      ]
      secrets = [
        {
          name      = "DB_USER"
          valueFrom = aws_secretsmanager_secret.db_credentials.arn
        },
        {
          name      = "DB_PASS"
          valueFrom = aws_secretsmanager_secret.db_credentials.arn
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/${var.ecs_task_family}"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
}

