output "security_group_ids" {
  description = "A map of security group names to their IDs"
  value       = { for sg in aws_security_group.sg : sg.name => sg.id }
}


output "alb_sg_id" {
  value = {
    for vpc_key, sg in aws_security_group.alb : vpc_key => sg.id
  }
}