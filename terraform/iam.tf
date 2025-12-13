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
        Resource = [
          aws_secretsmanager_secret.db_credentials.arn
        ]
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


# EC2 INSTANCE ROLE FOR ECS
resource "aws_iam_role" "ecs_instance_role" {
  name               = "${var.ecs_cluster_name}-ec2-role"
  assume_role_policy = file("${path.module}/ecs_instance_role.json")
}

# Every ECS EC2 instance present in ecs_cluster will have these policies attached to its role

# Pull container images, publish logs to CloudWatch and talk to other services securely
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
