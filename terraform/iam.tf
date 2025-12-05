# IAM Role for ECS Task Execution
resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_role_name
  # IAM Role Trust Policy for ECS Tasks
  assume_role_policy = file("${path.module}/ecs_assume_role_policy.json")
}

# Attach AmazonECSTaskExecutionRolePolicy to ECS Task Execution Role
resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role = aws_iam_role.ecs_task_execution_role.name

  # AmazonECSTaskExecutionRolePolicy -> allows ECS tasks to pull images from ECR and write logs to CloudWatch, retrieves secrets from Secrets Manager and Parameter Store, mount volumes etc.
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

