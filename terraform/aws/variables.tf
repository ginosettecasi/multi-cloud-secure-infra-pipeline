variable "trusted_ip" {
  description = "Trusted IP for SSH and HTTP"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC to deploy into"
  type        = string
}
