resource "aws_ecr_repository" "blog_repo" {
  name = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"
	
  lifecycle_policy {
    policy = file("${path.module}/ecr_lifecycle_policy.json")
  }
}
