variable "AWS_REGION" {
  type  = string
}

variable "AWS_ACCESS_KEY" {
  type  = string
}

variable "AWS_SECRET_KEY" {
  type  = string
}

variable "AWS_AMIS" {
  type = map(string)

  default = {
    "ap-northeast-2" = "ami-04cebc8d6c4f297a3" // t2.micro
  }
}