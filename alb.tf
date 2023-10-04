resource "aws_lb" "my_alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = ["sg-id"]  # Replace with your security group ID
  subnets            = ["subnet-id-1", "subnet-id-2"]  # Replace with your subnet IDs

  enable_deletion_protection = false

  enable_http2               = true
  idle_timeout               = 60
  enable_cross_zone_load_balancing = true
}

resource "aws_lb_listener" "app1_listener" {
  load_balancer_arn = aws_lb.my_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      status_code  = "200"
      message_body = "Hello, this is the default response for App1!"
    }
  }
}

resource "aws_lb_listener_rule" "app1_rule" {
  listener_arn = aws_lb_listener.app1_listener.arn
  priority     = 100

  action {
    type = "forward"

    target_group_arn = aws_lb_target_group.app1_target_group.arn
  }

  condition {
    path_pattern {
      values = ["/app1/*"]
    }
  }
}

resource "aws_lb_target_group" "app1_target_group" {
  name        = "app1-target-group"
  port        = 8080  # Replace with your backend service port
  protocol    = "HTTP"
  vpc_id      = "vpc-0123456789abcdef0"  # Replace with your VPC ID
  health_check {
    path                = "/"
    port                = "traffic-port"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# Similar configurations for app2, app3, etc.
