resource "aws_iam_role" "ecs_task_execution_role" {
  name = var.ecs_role_name
  assume_role_policy = file("${path.module}/ecs_assume_role_policy.json")
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_attach" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

