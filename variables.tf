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

variable "public_subnet_cidr_blocks" {
  type = map 
  description = "CIDR blocks for public subnets in different availability zones" 

  default = {
    eu-west-2a = "10.0.10.0/24",
    eu-west-2b = "10.0.11.0/24",
  }      
}

variable "private_subnet_cidr_blocks" {
  type = map
  description = "CIDR blocks for private subnets in different availability zones"     

  default = {
    eu-west-2a = "10.0.20.0/24",
    eu-west-2b = "10.0.21.0/24",
  }   
}