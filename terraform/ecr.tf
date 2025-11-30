resource "aws_ecr_repository" "blog_repo" {
	name = "blog_app_repo"
	image_tag_mutability = "IMMUTABLE"
	
	lifecycle_policy {
		policy = file("${path.module}/ecr_lifecycle_policy.json")
	}
 }
