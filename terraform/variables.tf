variable "aws_region" {
  type        = string
  description = "Represents the aws region"
}

variable "aws_cred_path" {
  type        = string
  description = "Represents the path of aws credentials file"
}

variable "ecr_repo_name" {
  type        = string
  description = "Represents the name of the ecr repository"
}

variable "vpc_cidr_block" {
  type        = string
  description = "Represents the cidr of the vpc"
}

variable "public_blog_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the public subnet configurations"
}

variable "blog_public_rt_tag" {
  type        = map(string)
  description = "Represents the tag associated with the route table of public subnet"
}

variable "pub_dest_cidr" {
  type        = string
  description = "Represents the cidr block of the destination of the route"
}

variable "private_blog_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the private subnet configurations"
}

variable "eip_tag" {
  type        = string
  description = "Represents the tag associated with EIP"
}

variable "nat_tag" {
  type        = string
  description = "Represents the tag associated with NAT gateway"
}

variable "private_blog_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the private subnet configurations"
}

variable "blog_private_rt_tag" {
  type        = string
  description = "Represents the tag associated with the route table of private subnet"
}

variable "alb_sg_config" {
  type = map(object({
    name        = string
    description = string
    tags        = map(string)
  }))
  description = "Contains the configurations associated with ALB security group"
}

variable "alb_ingress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the ingress rules associated with the ALB"
}

variable "alb_egress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the egress rules associated with the ALB"
}

variable "app_sg_config" {
  type = map(object({
    name        = string
    description = string
    tags        = map(string)
  }))
  description = "Contains the configurations associated with APP security group"
}

variable "app_ingress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the ingress rules associated with the app"
}

variable "app_egress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the egress rules associated with the app"
}

variable "db_sg_config" {
  type = map(object({
    name        = string
    description = string
    tags        = map(string)
  }))
  description = "Contains the configurations associated with DB security group"
}

variable "db_ingress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the ingress rules associated with the database"
}

variable "db_egress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
  description = "Contains the egress rules associated with the database"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Represents the ecs cluster name for Blog app"
}

variable "ecs_role_name" {
  type        = string
  description = "Represents the role name of the ecs"
}

variable "app_ec2_instance_type" {
  type        = string
  description = "Represents the instance type of the app instance"
}

variable "db_creds_secret_manager" {
  type        = string
  description = "Represents the name of secrets manager"
}

variable "db_username" {
  type        = string
  description = "Database username"
  sensitive   = true
}

variable "db_password" {
  type        = string
  description = "Database password"
  sensitive   = true
}

variable "ecs_task_family" {
  type        = string
  description = "Represents the name of the task defnition family(all the related task defnitions which are different to one another through config are grouped here)"
}

variable "task_cpu" {
  type        = number
  description = "Represents the alloted cpu for ecs tasks"
}

variable "task_memory" {
  type        = number
  description = "Represents the alloted memory for ecs tasks"
}


variable "app_port" {
  type        = number
  description = "Represents the port number of the application"
}


