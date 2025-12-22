
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
          valueFrom = data.aws_secretsmanager_secret.db_username.arn
        },
        {
          name      = "DB_PASSWORD"
          valueFrom = data.aws_secretsmanager_secret.db_password.arn
        }
      ]

      environment = [
        {
          name  = "DB_HOST"
          value = aws_db_instance.db_insance.address
        },
        {
          name  = "DB_PORT"
          value = tostring(var.app_port)
        },
        {
          name  = "DB_NAME"
          value = var.db_instance_db_name
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

