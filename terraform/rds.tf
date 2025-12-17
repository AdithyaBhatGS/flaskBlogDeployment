# To fetch the ids of the db subnets
locals {
  list_of_db_subnets = values(aws_subnet.private_db_subnet)[*].id
}

# Fetching the db creds
locals {
  db_creds = jsondecode(aws_secretsmanager_secret_version.db_credentials_version.secret_string)
}

# RDS SUBNET GROUP (DB SUBNETS)
resource "aws_db_subnet_group" "db_subnet_group" {
  name        = var.db_subnet_group_name
  description = var.db_subnet_group_description
  subnet_ids  = local.list_of_db_subnets

  tags = var.db_subnet_group_tags
}


# PARAMETER GROUP (configuration file for the db engine)
resource "aws_db_parameter_group" "mysql_param_group" {
  name   = var.db_param_grp_name
  family = var.db_param_grp_family

  dynamic "parameter" {
    for_each = var.param_config

    content {
      name  = parameter.key
      value = parameter.value
    }
  }

}


# MAIN RDS INSTANCE (MULTI-AZ)t
resource "aws_db_instance" "db_insance" {
  identifier              = var.db_instance_identifier
  engine                  = var.db_instance_engine
  engine_version          = var.db_instance_engine_version
  instance_class          = var.db_instance_instance_class
  allocated_storage       = var.db_instance_allocated_storage
  backup_retention_period = 7
  deletion_protection     = true
  storage_type            = var.db_instance_storage_type

  multi_az                  = true
  final_snapshot_identifier = var.db_instance_identifier
  username                  = local.db_creds.username
  password                  = local.db_creds.password

  db_name = var.db_instance_db_name

  port                = var.db_instance_port
  publicly_accessible = false

  db_subnet_group_name   = aws_db_subnet_group.db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.mysql_sg.id]
  parameter_group_name   = aws_db_parameter_group.mysql_param_group.name
  backup_window          = "02:00-02:30"
  skip_final_snapshot    = true

  tags = var.db_instance_tags
}
