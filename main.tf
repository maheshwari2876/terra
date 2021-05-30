resource "random_id" "random_id_prefix" {
  byte_length = 2
}
/*====
Variables used across all modules
======*/
locals {
  production_availability_zones = ["${var.region}a", "${var.region}b", "${var.region}c"]
}

module "Networking" {
  source = "./module/Networking"

  region               = "${var.region}"
  env                  = "${var.env}"
  vpc_cidr             = "${var.vpc_cidr}"
  public_subnets_cidr  = "${var.public_subnets_cidr}"
  private_subnet_cidr  = "${var.private_subnet_cidr}"
  availability_zones   = "${local.production_availability_zones}"
}


module "ec2" {
  source     = "./module/ec2pub"
  depends_on = [module.Networking]
}