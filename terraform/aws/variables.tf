variable "trusted_ip" {
  description = "The trusted IP address allowed to access SSH/HTTP"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the existing VPC to use"
  type        = string
}
