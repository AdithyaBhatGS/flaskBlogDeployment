# ECR Repository for Blog Application
resource "aws_ecr_repository" "blog_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }

}

# Lifecycle Policy for ECR Repository
resource "aws_ecr_lifecycle_policy" "life_cycle_policy_for_ecr" {
  repository = aws_ecr_repository.blog_repo.name
  # ECR Lifecycle Policy to retain only the last 10 images
  policy = file("${path.module}/ecr_lifecycle_policy.json")
}
