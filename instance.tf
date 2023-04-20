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

## Elastic IP
module ec2_eip {
    source = "./modules/eip"

    AWS_INSTACNE = aws_instance.docker-ec2.id
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

    // 4. Execute Remote
    provisioner "remote-exec" {
        inline = [
            "sudo apt-get update",

            ## NginX
            "sudo apt-get install -y nginx",
            "sudo systemctl enable nginx",
            "sudo systemctl start nginx",

            ## Docker
            "sudo apt-get install -y docker",
            "sudo service docker start",
            "sudo systemctl start nginx",

            ## Node
            "curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -",
            "sudo apt install -y nodejs",

            ## Git
            "sudo apt install -y git",

            ## Folder
            "mkdir -p /home/ubuntu/app",
            "cd /home/ubuntu/app",
            "git clone https://github.com/zkfmapf123/node-docker-practice.git",
            "cd node-docker-practice/",
            "npm install"
        ]
    }

    // 4. AWS KEY CONNECTION
    connection {
      host = coalesce(self.public_ip, self.private_ip)
      type="ssh"
      user = "ubuntu"
      private_key = file("./secrets/zkfmapf1234")
    }
}

output "eip" {
    value = aws_instance.docker-ec2.public_ip
}