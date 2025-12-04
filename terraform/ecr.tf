resource "aws_ecr_repository" "blog_repo" {
  name                 = var.ecr_repo_name
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

}

resource "aws_ecr_lifecycle_policy" "life_cycle_policy_for_ecr" {
  repository = aws_ecr_repository.blog_repo.name
  policy     = file("${path.module}/ecr_lifecycle_policy.json")
}
