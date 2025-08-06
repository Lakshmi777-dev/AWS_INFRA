#output "alb_dns_name" {
  #value = aws_lb.this.dns_name
#}

/*output "alb_dns_name" {
  value = aws_lb.pritunl_alb.dns_name
}*/

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "tg_arn" {
  value = aws_lb_target_group.tg.arn
}

output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

