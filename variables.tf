variable "awsRegion" {
  type        = string
  description = "AWS Region Name"
  default     = "us-east-1"
}

variable "vpc_cidr_block" {
  type        = string
  description = "base CIDR block for VPC"
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets_cidr_block" {
  type        = string
  description = "CIDR block for public subnets in VPC"
  default     = "10.0.0.0/24"
}

variable "enable_dns_hostnames" {
  type        = bool
  description = "Enable DNS hotnames in VPC"
  default     = true
}

variable "instance_type" {
  type        = string
  description = "type of EC2 Instance"
  default     = "t3.micro"
}

variable "company" {
  type        = string
  description = "company name for ressource tagging"
  default     = "f2i"
}

variable "project" {
  type        = string
  description = "project name for ressource tagging"
  # No default value 
}

variable "billing_code" {
  type        = string
  description = "billing code for ressource tagging"
  default     = "600627332709"
}