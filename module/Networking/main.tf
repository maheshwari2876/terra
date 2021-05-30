/*==========VPC=================*/
resource "aws_vpc" "vpc" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_hostnames = true
    enable_dns_support   = true
    tags = {
      "Name" = "${var.env}-vpc"
      "Environmet" = "${var.env}"
    }
}
/* ===========subnet============*/
/***Internet Gateway for public Subnet
resource "aws_internet_gateway" "ig" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
      "Name" = "${var.env}-igw"
      "Environmet" = "${var.env}"
    }
}***/
/****Elastic IP for NAT
resource "aws_eip" "nat_ip" {
    vpc = true
    depends_on = [aws_internet_gateway.ig]
} ****/
/*****NAT gateway 
resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.nat_ip.id}"
    subnet_id = "${element(aws_subnet.public_subnet.*.id, 0)}"
    depends_on = [aws_internet_gateway.ig]
    tags = {
      "Name" = "nat"
      "Environmet" = "${var.env}"
    }
}***/
/* =======Public_subnet==========*/
resource "aws_subnet" "public_subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    count                   = "1"
    cidr_block              = "${element(var.public_subnets_cidr,   count.index)}"
    availability_zone       = "${element(var.availability_zones,   count.index)}"
    map_public_ip_on_launch = true
    tags = {
    Name        = "${var.env}-${element(var.availability_zones, count.index)}-public-subnet"
    Environment = "${var.env}"
  }
}
/* =======Private_subnet==========*/
resource "aws_subnet" "private_subnet" {
    vpc_id = "${aws_vpc.vpc.id}"
    count                   =  length(var.public_subnets_cidr)
    cidr_block              = "${element(var.private_subnet_cidr, count.index)}"
    availability_zone       = "${element(var.availability_zones,   count.index)}"
    map_public_ip_on_launch = false
    tags = {
    Name        = "${var.env}-${element(var.availability_zones, count.index)}-private-subnet"
    Environment = "${var.env}"
  }
}
/* Route table for Public subnet*/
resource "aws_route_table" "public" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
    Name        = "${var.env}-public-route-table"
    Environment = "${var.env}"
  }
}
/* Route table for private subnet
resource "aws_route_table" "private" {
    vpc_id = "${aws_vpc.vpc.id}"
    tags = {
    Name        = "${var.env}-private-route-table"
    Environment = "${var.env}"
  }
}
resource "aws_route" "public_internet_gateway" {
    route_table_id = "${aws_route_table.public.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.ig.id}"    
}
resource "aws_route" "private_nat_gateway" {
    route_table_id = "${aws_route_table.private.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.nat.id}"
}*/
/* Route table association
resource "aws_route_table_association" "public" {
    count = "${length(var.public_subnets_cidr)}"
    subnet_id      = "${element(aws_subnet.public_subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.public.id}"
}
resource "aws_route_table_association" "private" {
    count = "${length(var.private_subnet_cidr)}"
    subnet_id      = "${element(aws_subnet.private_subnet.*.id, count.index)}"
    route_table_id = "${aws_route_table.private.id}"
}*/
/***=========VPC default security group========
resource "aws_security_group" "default" {
    name = "${var.env}-default-sg"
    description = "Default security group to allow inbound/outbound from the VPC"
    vpc_id = "${aws_vpc.vpc.id}"
    depends_on = [aws_vpc.vpc]

    ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  
  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }
  tags = {
    Environment = "${var.env}"
  }
}**/

