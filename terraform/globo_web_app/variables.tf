# Assign environment variable by exporting.
# $ TF_VAR_aws_secret_key=<secretKey>
variable "aws_access_key" {
  type = string
  description = "AWS Access Key"
  sensitive = true
}

# Assign environment variable by exporting.
# $ TF_VAR_aws_secret_key=<secretKey>
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

variable "vpc_cidr_block" {
  type        = string
  description = "Base CIDR Block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_subnets_cidr_block" {
  type        = list(string)
  description = "CIDR Block for Subnet 1 in VPC"
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
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