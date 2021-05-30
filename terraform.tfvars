region = "us-east-2"
env    = "testing"

/* module networking */
vpc_cidr            = "10.10.0.0/16"
public_subnets_cidr = ["10.10.1.0/24"]                 //List of Public subnet cidr range
private_subnet_cidr = ["10.10.2.0/24", "10.10.3.0/24"] //List of private subnet cidr range
availability_zones  = ["us-east-2a"]

