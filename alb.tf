resource "aws_lb" "alb" {
  name               = var.ALB_NAME
  internal           = var.INTERNAL    # if true private flase public ALB
  load_balancer_type = "application"
  security_groups    = 
  subnets            = 




  tags = {
    Environment = "roboshop-${var.ENV}-alb"
  }
}