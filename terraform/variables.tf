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

variable "vpc_tag" {
  type        = map(string)
  description = "Represents the tag of the vpc"
}

variable "public_blog_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the public subnet configurations"
}

variable "private_app_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the private subnet configurations for app"
}

variable "private_db_subnet" {
  type = map(object({
    cidr_block        = string
    availability_zone = string
    tags              = map(string)
  }))
  description = "Represents the private subnet configurations for db"
}

variable "blog_public_rt_tag" {
  type        = map(string)
  description = "Represents the tag associated with the route table of public subnet"
}

variable "pub_dest_cidr" {
  type        = string
  description = "Represents the cidr block of the destination of the route"
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

variable "igw_tag" {
  type        = map(string)
  description = "Represents the tag associated with internet gateway"
}

variable "blog_private_rt_tag" {
  type        = map(string)
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

variable "ecs_host_sg_description" {
  type        = string
  description = "Represents the security group associated with ecs ec2 hosts"
}

variable "ecs_host_egress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
}

variable "ecs_host_ingress" {
  type = map(object({
    description = string
    from_port   = number
    to_port     = number
    cidr_blocks = string
    protocol    = string
  }))
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

variable "desired_capacity" {
  type        = number
  description = "Represents the desired capacity of ecs ec2 instances"
}

variable "max_size" {
  type        = number
  description = "Represents the max size of ecs ec2 instances"
}

variable "min_size" {
  type        = number
  description = "Represents the min size of ecs ec2 instances"
}

variable "service_desired_count" {
  type        = string
  description = "Represents the number of flask app instances running at all times"
}

variable "db_subnet_group_name" {
  type        = string
  description = "Represents the name of the database subnet group"
}

variable "db_subnet_group_description" {
  type        = string
  description = "Represents the subnet group description of the database subnet group"
}

variable "db_subnet_group_tags" {
  type        = map(string)
  description = "Represents the tags associated with the database subnet group"
}

variable "param_config" {
  type        = map(string)
  description = "Configuration information for the db engine"
}

variable "db_param_grp_name" {
  type        = string
  description = "Represents the name of the database parameter group"
}

variable "db_param_grp_family" {
  type        = string
  description = "Represents the family of the database parameter group"
}

variable "db_instance_identifier" {
  type        = string
  description = "Represents the name of the RDS instance"
}

variable "db_instance_engine" {
  type        = string
  description = "Represents the name of the database engine"
}

variable "db_instance_engine_version" {
  type        = string
  description = "Represents the version of the database engine"
}

variable "db_instance_instance_class" {
  type        = string
  description = "Represents the RDS instance class"
}

variable "db_instance_allocated_storage" {
  type        = number
  description = "Represents the allocated storage in GB"
}

variable "db_instance_storage_type" {
  type        = string
  description = "Represents the storage type (gp3/ gp2/ io1/ io2/ io2 block express)"
}

variable "db_instance_port" {
  type        = number
  description = "Represents the port on which db access the connections"
}

variable "db_instance_db_name" {
  type        = string
  description = "Represents the name of the database when the database instance is created"
}

variable "db_instance_tags" {
  type        = map(string)
  description = "Represents the tag associated with the database instance"
}

variable "lb_name" {
  type        = string
  description = "Represents the load balancer name of Application load balancer"
}

variable "lb_tag" {
  type        = map(string)
  description = "Represents the tag associated with the application load balancer"
}

variable "alb_target_grp_config" {
  type = object({
    name                = string
    port                = number
    protocol            = string
    path                = string
    interval            = number
    timeout             = number
    healthy_threshold   = number
    unhealthy_threshold = number
    tags                = map(string)
  })
}

variable "alb_listener_port" {
  type        = number
  description = "Represents the port of the ALB listener"
}

variable "alb_listener_protocol" {
  type        = string
  description = "Represents the protocol of the ALB listener"
}
