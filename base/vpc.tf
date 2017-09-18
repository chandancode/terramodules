resource "aws_vpc" "vpc_tuto" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "TestVPC"
  }
}

resource "aws_security_group" "FrontEnd" {
  name = "FrontEnd"
  tags {
        Name = "FrontEnd"
  }
  description = "ONLY HTTP CONNECTION INBOUD"
  vpc_id = "${aws_vpc.vpc_tuto.id}"

  ingress {
        from_port = 80
        to_port = 80
        protocol = "TCP"
        cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = "22"
    to_port     = "22"
    protocol    = "TCP"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_subnet" "public_subnet_ap_south_1a" {
  vpc_id                  = "${aws_vpc.vpc_tuto.id}"
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"
  tags = {
  	Name =  "Subnet public az 1a"
  }
}

resource "aws_subnet" "private_1_subnet_ap_south_1b" {
  vpc_id                  = "${aws_vpc.vpc_tuto.id}"
  cidr_block              = "10.0.2.0/24"
  availability_zone = "us-east-1b"
  tags = {
  	Name =  "Subnet private 1 az 1b"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.vpc_tuto.id}"
  tags {
        Name = "InternetGateway"
    }
}

resource "aws_route" "internet_access" {
  route_table_id         = "${aws_vpc.vpc_tuto.main_route_table_id}"
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = "${aws_internet_gateway.gw.id}"
}

resource "aws_eip" "tuto_eip" {
  vpc      = true
  depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_nat_gateway" "nat" {
    allocation_id = "${aws_eip.tuto_eip.id}"
    subnet_id = "${aws_subnet.public_subnet_ap_south_1a.id}"
    depends_on = ["aws_internet_gateway.gw"]
} 


resource "aws_route_table" "private_route_table" {
    vpc_id = "${aws_vpc.vpc_tuto.id}"
 
    tags {
        Name = "Private route table"
    }
}
 
resource "aws_route" "private_route" {
	route_table_id  = "${aws_route_table.private_route_table.id}"
	destination_cidr_block = "0.0.0.0/0"
	nat_gateway_id = "${aws_nat_gateway.nat.id}"
}


resource "aws_route_table_association" "public_subnet_ap_south__1a_association" {
    subnet_id = "${aws_subnet.public_subnet_ap_south_1a.id}"
    route_table_id = "${aws_vpc.vpc_tuto.main_route_table_id}"
}
 
# Associate subnet private_1_subnet_ap_south__1b to private route table
resource "aws_route_table_association" "pr_1_subnet_ap_south_1b_association" {
    subnet_id = "${aws_subnet.private_1_subnet_ap_south_1b.id}"
    route_table_id = "${aws_route_table.private_route_table.id}"
}






#resource "aws_ebs_volume" "myebs" {
#        count                           = "1"
#        availability_zone               = "ap-south-1a"
#        size                            = "1"
#        type                            = "gp2"
#	tags {
#
#		Name = "Mynewvol"
#
# 	}
#}


#resource "aws_volume_attachment" "ebs_att" {
#  device_name = "/dev/sdh"
#  volume_id   = "${aws_ebs_volume.myebs.id}"
#  instance_id = "${aws_instance.pub_example.id}"
#}
