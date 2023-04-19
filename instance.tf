## VPC
module ec2_vpc {
    source = "./modules/vpc"

    AWS_REGION = var.AWS_REGION
}

## SG
module ec2_sg {
    source = "./modules/security-group"

    AWS_VPC_ID = module.ec2_vpc.vpc_id
}

resource "aws_key_pair" "leedonggyu" {
    key_name = "leedonggyu"
    public_key = file("./secrets/zkfmapf1234.pub")
}

resource "aws_instance" "docker-ec2" {
    ami           = "${var.AWS_AMIS[var.AWS_REGION]}"
    instance_type = "t2.micro"

    // 1. subnet_id
    subnet_id = module.ec2_vpc.subnet_id

    // 2. security_groups
    vpc_security_group_ids = [
        module.ec2_sg.allow_ssh_id
    ]

    // 3. key name
    key_name = aws_key_pair.leedonggyu.key_name

    // 3. Execute Remote
    # provisioner "remote-exec" {
    #     inline = [
    #         "sudo apt-get update",
    #         "sudo apt-get install -y nginx",
    #         "sudo apt-get install -y docker.io",
    #         "sudo systemctl enable nginx",
    #         "sudo systemctl enable docker",
    #         "sudo systemctl start nginx",
    #         "sudo systemctl start docker"
    #     ]
    # }

    // 4. AWS KEY CONNECTION
    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type="ssh"
      user = "ubuntu"
      private_key = file("./secrets/zkfmapf1234")
    }
}

output "ec2_public_ip" {
    value = aws_instance.docker-ec2.public_ip
}