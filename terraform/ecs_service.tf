
locals {
  list_of_private_app_subnets = values(aws_subnet.private_app_subnet)[*].id
  list_of_private_db_subnets  = values(aws_subnet.private_db_subnet)[*].id
}

# ECS SERVICE (REGISTER TASKS TO ALB)

resource "aws_ecs_service" "flask_service" {
  name            = "${var.ecs_cluster_name}-service"
  cluster         = aws_ecs_cluster.blog_cluster.id
  task_definition = aws_ecs_task_definition.flask_task.arn
  launch_type     = "EC2"
  desired_count   = var.service_desired_count

  network_configuration {
    subnets          = local.list_of_private_app_subnets
    security_groups  = [aws_security_group.app_sg.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.blog_tg.arn
    container_name   = "flask"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.http]
}

