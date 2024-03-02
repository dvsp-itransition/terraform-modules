data "aws_availability_zones" "available" {}

locals {  
  used_zones =  slice(data.aws_availability_zones.available.names, 0, var.count_az)     
}

# CIDR blocks for public and private subnets in each used availability zone.      
locals {  
  subnet_cidr_blocks = {
    for idx, az in local.used_zones : az => {
      public  = cidrsubnet(var.vpc_cidr, 8, idx * 4)
      private = cidrsubnet(var.vpc_cidr, 8, idx * 4 + 1)
    }
  }  
}

