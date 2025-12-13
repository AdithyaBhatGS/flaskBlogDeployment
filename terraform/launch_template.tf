# LAUNCH TEMPLATE (PRIVATE SUBNET ECS INSTANCES)

data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.ecs_cluster_name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.app_ec2_instance_type

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs_instance_profile.name
  }

  network_interfaces {
    security_groups = [aws_security_group.ecs_host_sg.id]
  }

  user_data = base64encode(<<EOF
#!/bin/bash
echo ECS_CLUSTER=${aws_ecs_cluster.blog_cluster.name} >> /etc/ecs/ecs.config
EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.ecs_cluster_name}-instance"
    }
  }
}

