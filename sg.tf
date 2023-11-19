# Creates public alb security group
resource "aws_security_group" "alb_public" {
  count = var.INTERNAL ? 0 : 1  
  name        = "roboshop-${var.ENV}-public-alb-sg"
  description = "Allows Only public traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID


  ingress {
    description      = "Allows External HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-${var.ENV}-public-alb-sg"
  }
}

# Creates private alb security group
resource "aws_security_group" "alb_private" {
  count = var.INTERNAL ? 1 : 0  
  name        = "roboshop-${var.ENV}-private-alb-sg"
  description = "Allows Only private traffic"
  vpc_id      = data.terraform_remote_state.vpc.outputs.VPC_ID


  ingress {
    description      = "Allows internal HTTP Traffic"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = [data.terraform_remote_state.vpc.outputs.VPC_ID, data.terraform_remote_state.vpc.outputs.DEFAULT_VPC_CIDR]

  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "roboshop-${var.ENV}-private-alb-sg"
  }
}

## here we have used count to make sure that the private sg is created when the internal is 
## true and alb-private is called vice vesa for public
## other wise when the terrforms tries to create the sgs both private and public
## each time the modules are called . this will create a conflict