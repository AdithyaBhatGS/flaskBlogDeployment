# AWS Secrets Manager Secret for Database Credentials
resource "aws_secretsmanager_secret" "db_credentials" {
  name        = var.db_creds_secret_manager
  description = "Represents the database credentials for the Flask blog application"
}

# AWS Secrets Manager Secret Version for Database Credentials
resource "aws_secretsmanager_secret_version" "db_credentials_version" {
  secret_id = aws_secretsmanager_secret.db_credentials.id
  secret_string = jsonencode({
    username = var.db_username
    password = var.db_password
  })
}

