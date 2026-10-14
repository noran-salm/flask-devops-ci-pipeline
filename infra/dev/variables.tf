variable "aws_region" {
  type = string
}

variable "aws_profile" {
  type = string
}

variable "env_name" {
  type = string
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "key_name" {
  type        = string
  description = "Name of the existing SSH key pair in AWS"
}
variable "my_ip" {
  type        = string
  description = "Your public IP address (e.g., 203.0.113.50)"
}