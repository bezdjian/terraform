## AWS ALB
resource "aws_lb" "nginx" {
  name               = "globo-web-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]

  enable_deletion_protection = false

  tags = local.common_tags
}
## AWS LB target group
resource "aws_lb_target_group" "nginx-tg" {
  name     = "globo-lb-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  tags = local.common_tags
}
## listener
resource "aws_lb_listener" "nginx-lb-listener" {
  load_balancer_arn = aws_lb.nginx.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.nginx-tg.arn
  }

  tags = local.common_tags
}
## TG attachment
resource "aws_lb_target_group_attachment" "nginx-tg-attachment-nginx1" {
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginx-instance-1.id
  port             = 80
}
resource "aws_lb_target_group_attachment" "nginx-tg-attachment-nginx2" {
  target_group_arn = aws_lb_target_group.nginx-tg.arn
  target_id        = aws_instance.nginx-instance-2.id
  port             = 80
}