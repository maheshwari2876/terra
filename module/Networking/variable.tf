variable "region" {
  description = "AWS deployment Region"
}
variable "env" {
  description = "The Deployment environment"
}

variable "vpc_cidr" {
  description = "The CIDR block of the vpc"
}

variable "public_subnets_cidr" {
  type        = list
  description = "The CIDR block for the public subnet"
}

variable "private_subnet_cidr" {
    type = list
    description = " describe your variable"
}

/*variable "region" {
  description = "The region to launch the bastion host"
}*/

variable "availability_zones" {
  type        = list
  description = "The az that the resources will be launched"
}
