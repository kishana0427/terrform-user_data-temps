provider "aws" {}
data "template_file" "myuserdata" {
  template = "${file("${path.cwd}/myuserdata.tpl")}"}variable "amis" {
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
  key_name = "ireland"
  instance_type = "t2.micro"
  user_data = "${data.template_cloudinit_config.config.rendered}"
}data "template_cloudinit_config" "config" {
  base64_encode = truepart {
    content_type = "text/x-shellscript"
    content      = "${data.template_file.myuserdata.template}"
     }
  part {
    content_type = "text/x-shellscript"
    content  = "${file("${path.cwd}/installsysstat.sh")}"
  }
}
