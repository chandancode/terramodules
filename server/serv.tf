resource "aws_instance" "pub_example" {
  ami           = "ami-c998b6b2"
  instance_type = "${var.modname}"
  key_name = "terra"
  vpc_security_group_ids = ["${var.awssecgp}"]
  subnet_id = "${var.awssub}"
  tags {


      Name = "My pub instance"

 }


}
