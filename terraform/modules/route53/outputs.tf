output "frontend_fqdn" {
  value = aws_route53_record.frontend.fqdn
}

output "api_fqdn" {
  value = var.alb_dns_name != "" ? aws_route53_record.api[0].fqdn : ""
}
