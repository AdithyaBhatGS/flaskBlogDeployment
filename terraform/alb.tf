# Creating ALB
resource "aws_lb" "app_alb" {
  name               = var.lb_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.blog_alb_sg.id]
  subnets            = sort([for s in aws_subnet.public_blog_subnet : s.id])
  tags               = var.lb_tag
}

# Target Group 
resource "aws_lb_target_group" "blog_tg" {
  name        = var.alb_target_grp_config.name
  port        = var.alb_target_grp_config.port
  protocol    = var.alb_target_grp_config.protocol
  target_type = "ip"
  vpc_id      = aws_vpc.blog_vpc.id
  health_check {
    path                = var.alb_target_grp_config.path
    protocol            = var.alb_target_grp_config.protocol
    port                = var.alb_target_grp_config.port
    interval            = var.alb_target_grp_config.interval
    timeout             = var.alb_target_grp_config.timeout
    healthy_threshold   = var.alb_target_grp_config.healthy_threshold
    unhealthy_threshold = var.alb_target_grp_config.unhealthy_threshold
  }
  tags = var.alb_target_grp_config.tags
}

# ALB Listener
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = var.alb_listener_port
  protocol          = var.alb_listener_protocol
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blog_tg.arn
  }
}
