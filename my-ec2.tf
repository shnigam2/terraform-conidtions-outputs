variable "instancecount" {
  type = number
}

variable "apptype" {

}

variable "instancetype" {
  type = map
  default = {
    "http" = "t2.micro"
    "apache" = "t2.micro"
    "java" = "t2.micro"
    "erp" = "t3.small"
  }
}

data "aws_ami" "http" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["http-image 2021-09-03T11-52-39.404Z"]
  }
}

data "aws_ami" "apache" {
  most_recent = true
  owners = ["self"]

  filter {
    name = "name"
    values = ["http-image 2021-09-03T11-52-39.404Z"]
  }
}


resource "aws_instance" "http" {
    ami = data.aws_ami.http.id
    instance_type = var.instancetype[var.apptype]
    count = var.apptype == "http" ? var.instancecount : 0
    tags = {
      Name = "HTTp-Instance"
    }
    #count = var.instancecount
}


resource "aws_instance" "apache" {
    ami = data.aws_ami.http.id
    instance_type = var.instancetype[var.apptype]
    count = var.apptype == "apache" ? var.instancecount : 0
    tags = {
      Name = "Apache-Instance"
    }
    #count = var.instancecount
}


output "public_http_ip" {
  value = var.apptype == "http" ? aws_instance.http.*.public_ip : null
}

output "public_apache_ip" {
  value = var.apptype == "apache" ? aws_instance.apache.*.public_ip : null
}

