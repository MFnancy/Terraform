resource "aws_launch_configuration" "tf_web" {
  image_id        = "ami-04a81a99f5ec58529"
  instance_type   = "t3.micro"
  security_groups = [aws_security_group.tf.id]
  user_data       = <<-EOF
                #!/bin/bash
                echo "Hello,world" > index.html
                nohup busybox httpd -f -p ${var.http_port} &
                EOF
}

resource "aws_autoscaling_group" "tf_asg" {
  name                 = "myasg"
  max_size             = 4
  min_size             = 2
  # desired_capacity     = 3
  # force_delete         = true
  launch_configuration = aws_launch_configuration.tf_web.name
  vpc_zone_identifier  = data.aws_subnets.default.ids
   target_group_arns = [aws_lb_target_group.target_tf.arn]
   health_check_type = "ELB"



  tag {
    key                 = "name"
    value               = "tf_asg"
    propagate_at_launch = true
  }
}

resource "aws_lb" "test" {
  name               = "test-lb-tf"
  # internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.tf.id]
  subnets            = data.aws_subnets.default.ids

  # enable_deletion_protection = true


  tags = {
    Environment = "development"
  }
}


resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.test.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code  = 404
    }
  }
}

resource "aws_lb_target_group" "target_tf" {
  name     = "tf-lb-tg"
  port     = var.http
  protocol = "HTTP"
  vpc_id   = data.aws_vpc.default.id


  health_check {
  path                = "/"
  protocol            = "HTTP"
  matcher             = "200"
  interval            = 15
  timeout             = 3
  healthy_threshold   = 2
  unhealthy_threshold = 2
  

}
}

resource "aws_lb_listener_rule" "listener_tf" {
  listener_arn = aws_lb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target_tf.arn
  }

  condition {
    path_pattern {
      values = ["*"]
    }
  }
}