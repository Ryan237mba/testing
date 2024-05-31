resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = local.vpc_name
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = local.igw_name
  }
}

resource "aws_subnet" "public_subnet" {
  count=3
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${cidrsubnet(var.vpc_cidr,8, count.index)}"
  map_public_ip_on_launch = "true"
  tags = {
    Name = "${local.public_subnet_name}_${count.index}"
  }
}
 

resource "aws_subnet" "private_subnet" {
  count=3
  vpc_id     = aws_vpc.vpc.id
  cidr_block = "${cidrsubnet(var.vpc_cidr,6, count.index + 2)}"
  tags = {
    Name = "${local.private_subnet_name}_${count.index}"
  }
}

resource "aws_subnet" "database" {
count = 3
vpc_id = aws_vpc.vpc.id
cidr_block = "${cidrsubnet(var.vpc_cidr,4, count.index + 4)}"
tags = {
  Name = "dbsub_${count.index}"
}

}
resource "aws_route_table_association" "pub_rt" {
  count=3
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public_rt.id
}

resource "aws_route_table_association" "pri_rt" {
   count=3
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private_rt.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = local.public_route_table
  }
}

resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = local.private_route_table
  }
}
resource "aws_route_table" "database" {
vpc_id = aws_vpc.vpc.id
tags = {
  Name= "database-route-database"
}
}

resource "aws_route_table_association" "database" {
  count = 3
  subnet_id = element(aws_subnet.database.*.id, count.index)
  route_table_id = aws_route_table.database.id
}

resource "aws_eip" "lb" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.lb.id
  subnet_id      = element(aws_subnet.public_subnet.*.id, 0)

  tags = {
    Name = local.ngw_name
  }

  depends_on = [aws_internet_gateway.gw]
}



resource "aws_db_subnet_group" "db_sb_gp" {
  name       = "main"
  subnet_ids = "${aws_subnet.database.*.id}"
  tags = {
    Name = "My DB subnet group"
  }
}