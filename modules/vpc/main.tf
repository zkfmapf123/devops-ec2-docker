variable "AWS_REGION" {
    type = string
}

# VPC
resource "aws_vpc" "main" {
    cidr_block = "10.0.0.0/16"
    instance_tenancy = "default"
    enable_dns_support = true 
    enable_dns_hostnames = true
}

# Public Subnet
resource "aws_subnet" "main-public" {
    vpc_id = aws_vpc.main.id
    cidr_block = "10.0.1.0/24"
    map_public_ip_on_launch = true
    availability_zone = "${var.AWS_REGION}a"
}

# Internet GW
resource "aws_internet_gateway" "main-gw" {
    vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main-rt" {
    vpc_id = aws_vpc.main.id

    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.main-gw.id
    }
}

# Mapping Route Table 
resource "aws_route_table_association" "public-rt-association" {
    subnet_id = aws_subnet.main-public.id
    route_table_id = aws_route_table.main-rt.id
}

output vpc_id {
    value = aws_vpc.main.id
}

output subnet_id {
    value = aws_subnet.main-public.id
}

