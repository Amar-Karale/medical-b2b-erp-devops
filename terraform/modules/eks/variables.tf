variable "cluster_name" {
  type = string
}

variable "kubernetes_version" {
  type    = string
  default = "1.34"
}

variable "vpc_id" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "node_instance_types" {
  type = list(string)
}

variable "capacity_type" {
  type = string
}

variable "node_desired_count" {
  type = number
}

variable "node_min_count" {
  type = number
}

variable "node_max_count" {
  type = number
}

variable "public_endpoint" {
  type = bool
}

variable "public_access_cidrs" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}
