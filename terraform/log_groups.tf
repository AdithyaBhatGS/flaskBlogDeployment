# CLOUDWATCH LOG GROUP (FOR TASK)
resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "/ecs/${var.ecs_task_family}"
  retention_in_days = 30
}
