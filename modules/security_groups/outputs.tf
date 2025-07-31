output "security_group_ids" {
  description = "A map of security group names to their IDs"
  value       = { for sg in aws_security_group.sg : sg.name => sg.id }
}
