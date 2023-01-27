provider "aws" {}
locals {
  instance-userdata = <<EOF
#!/bin/bash
export PATH=$PATH:/usr/local/bin
which pip >/dev/null
if [ $? -ne 0 ];
then
  echo 'PIP NOT PRESENT'
  if [ -n "$(which yum)" ]; 
  then
    yum install -y python-pip
  else 
    apt-get -y update && apt-get -y install python-pip
  fi
else 
  echo 'PIP ALREADY PRESENT'
fi
EOF
}variable "amis" {
  type = "map"
  default = {
    "eu-west-1" = "ami-0c21ae4a3bd190229"
    "us-east-1" = "ami-0922553b7b0369273"
  }
}
variable "region" {
  type = "string"
  default = "us-east-1"
}resource "aws_instance" "myinstance1" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  user_data_base64 = "${base64encode(local.instance-userdata)}"
}
