variable "vpc_cidr" {  
  type        = string
  description = "CIDR block for VPC"  
}

variable "region" {  
  type        = string
  description = "The region where the infrastructure will be deployed" 
}

variable "environment" {  
  type        = string
  description = "The environment for which the infrastructure is intended (e.g., dev, test, prod)"
}

variable "count_az" {  
  default = 2  
  type = number
  description = "The number of availability zones to be used."
}

variable "cidr_block_dr" {
  description = "The CIDR block for the default route. Default value is 0.0.0.0/0, which represents all IPv4 addresses."
  default     = "0.0.0.0/0"
  type        = string
}

