# Fetching the database username
data "aws_secretsmanager_secret" "db_username" {
  name = "blog/db/username"
}

# Fetching the database password
data "aws_secretsmanager_secret" "db_password" {
  name = "blog/db/password"
}


