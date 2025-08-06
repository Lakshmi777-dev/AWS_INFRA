resource "aws_security_group" "sg" {
  for_each = { for sg in var.security_groups : sg.name => sg }

  name        = each.value.name
  description = "Security group ${each.value.name} for VPC ${each.value.vpc_key}"
  vpc_id      = var.vpc_ids[each.value.vpc_key]

  dynamic "ingress" {
    for_each = each.value.ingress_rules
    content {
      description = ingress.value.description
      from_port   = ingress.value.from_port
      to_port     = ingress.value.to_port
      protocol    = ingress.value.protocol
      cidr_blocks = ingress.value.cidr_blocks
      #security_group_id = aws_security_group.this[each.key].id
    }
  }

  dynamic "egress" {
    for_each = each.value.egress_rules
    content {
      description = egress.value.description
      from_port   = egress.value.from_port
      to_port     = egress.value.to_port
      protocol    = egress.value.protocol
      cidr_blocks = egress.value.cidr_blocks
    }
  }

  tags = {
    Name = each.value.name
    #Name = "jenkins-sg"
  }
}

resource "aws_security_group" "alb" {
  for_each    = var.vpc_ids
  name        = "${each.key}-alb-sg"
  description = "Allow traffic for ALB in ${each.key}"
  vpc_id      = each.value
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "alb-sg"
  }
}


