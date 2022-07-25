# Target Group for Web App
resource "aws_alb_target_group" "api_target_group" {
  name        = "${var.cluster_name}-alb-target-group"
  port        = var.container_port
  protocol    = "HTTP"
  vpc_id      = aws_vpc.cluster_vpc.id
  target_type = "ip"

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [aws_alb.app_alb]
}

resource "aws_alb" "app_alb" {
  name            = "${var.cluster_name}-alb"
  subnets         = [aws_subnet.public_subnet_us_east_1a.id, aws_subnet.public_subnet_us_east_1b.id]
  security_groups = [aws_security_group.app_sg.id, aws_security_group.alb_sg.id]
}

resource "aws_alb_listener" "web_app" {
  load_balancer_arn = aws_alb.app_alb.arn
  port              = var.alb_port
  protocol          = "HTTP"
  depends_on        = [aws_alb_target_group.api_target_group]

  default_action {
    target_group_arn = aws_alb_target_group.api_target_group.arn
    type             = "forward"
  }
}
