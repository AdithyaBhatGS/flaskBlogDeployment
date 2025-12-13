# ECS CLUSTER
resource "aws_ecs_cluster" "blog_cluster" {
  name = var.ecs_cluster_name
}
