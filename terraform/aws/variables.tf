variable "trusted_ip" {
  description = "The trusted IP for access (e.g., developer's public IP)"
  type        = string
}

variable "vpc_id" {
  description = "ID of the existing VPC"
  type        = string
}
