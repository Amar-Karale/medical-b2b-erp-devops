variable "aws_region" {
  type    = string
  default = "us-west-1"
}

variable "domain_name" {
  type    = string
  default = "domainexpension.online"
}

variable "acm_certificate_arn" {
  type    = string
  default = ""
}

variable "developer_ip_cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "alb_dns_name" {
  type    = string
  default = ""
}
