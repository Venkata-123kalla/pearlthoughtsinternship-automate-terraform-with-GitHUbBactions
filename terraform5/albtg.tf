resource "aws_lb" "alb" {
  name               = "strapi-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [aws_subnet.subnet1.id, aws_subnet.subnet2.id]
}

resource "aws_lb_target_group" "blue" {
  name         = "tg-blue"
  port         = 1337
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_target_group" "green" {
  name         = "tg-green"
  port         = 1337
  protocol     = "HTTP"
  vpc_id       = aws_vpc.main.id
  target_type  = "ip"
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue.arn
  }
}


