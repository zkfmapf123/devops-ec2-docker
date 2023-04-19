variable "AWS_VPC_ID" {
    type = string
}

# Common Security Group for EC2 instances
resource "aws_security_group" "allow-ssh" {
    vpc_id = var.AWS_VPC_ID
    name = "allow-ssh"
    description = "Security Group for SSH"

    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
 
    // ssh
    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    // http
    ingress {
        from_port = 8080
        to_port = 8080
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
}

output allow_ssh_id {
    value = aws_security_group.allow-ssh.id
}