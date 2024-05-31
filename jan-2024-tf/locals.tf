locals {
  vpc_name            = "${var.Team}-vpc"
  private_subnet_name = "private-subnet-${local.vpc_name}"
  public_subnet_name  = "public-subnet-${local.vpc_name}"
  public_route_table  = "public_rt"
  private_route_table = "private_rt"
  igw_name            = "${local.vpc_name}-igw"
  ngw_name            = "${local.vpc_name}-ngw"
  sg_name             = "${local.vpc_name}-sg"
  sg_ports            = ["3000", "80", "443", "22"]
}