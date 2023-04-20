variable "AWS_INSTACNE" {
  type= string
}

resource "aws_eip" "vpc_ec2_eip"{
    instance = var.AWS_INSTACNE
    vpc = true
}