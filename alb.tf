resource "aws_lb" "alb" {
  name               = var.ALB_NAME
  internal           = var.INTERNAL    # if true private flase public ALB
  load_balancer_type = "application"
  security_groups    = var.INTERNAL ? [aws_security_group.alb_private.id] : [aws_security_group.alb_public.id]
  subnets            = var.INTERNAL ? data.terraform_remote_state.vpc.outputs.PRIVATE_SUBNET_IDS : data.terraform_remote_state.vpc.outputs.PUBLIC_SUBNET_IDS

## conditions in terraforms 
## if we create a private alb then security group and subnets should come
## up with private sg and subnet

## if we select false in internal public load balncer will be created and 
## sg and subnet should be public

# The syntax of a conditional expression is as follows:
# condition ? true_val : false_val


  tags = {
    Name = var.ALB_NAME
  }
}

