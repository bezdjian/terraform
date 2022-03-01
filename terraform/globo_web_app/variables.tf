variable "aws_access_key" {
  type = string
  description = "AWS Access Key"
  sensitive = true
}

variable "aws_secret_key" {
  type = string
  description = "AWS Secret Key"
  sensitive = true
}

variable "aws_region" {
  type = string
  default = "eu-west-1" # Ireland
  description = "AWS Region"
}

variable "ecs_instance_type" {
  type = string
  default = "t3.micro"
  description = "EC2 instance type"
}

variable "company" {
  type        = string
  description = "Company name for resource tagging"
  default     = "MultiSoftUniverse"
}

variable "project" {
  type        = string
  description = "Project name for resource tagging"
}

variable "billing_code" {
  type        = string
  description = "Billing code for resource tagging"
}