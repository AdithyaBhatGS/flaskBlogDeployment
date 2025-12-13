# AUTO SCALING GROUP (ECS EC2 HOSTS)
resource "aws_autoscaling_group" "ecs_asg" {
  name                      = "${var.ecs_cluster_name}-asg"
  desired_capacity          = var.desired_capacity
  max_size                  = var.max_size
  min_size                  = var.min_size
  vpc_zone_identifier       = local.list_of_private_app_subnets
  health_check_type         = "EC2"
  health_check_grace_period = 300
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.ecs_cluster_name}-ecs-ec2"
    propagate_at_launch = true
  }
}
