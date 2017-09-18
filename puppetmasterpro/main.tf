data "template_file" "bootstrap" {
  
  template = "${file("${path.module}/${var.bootstrap_script_path}")}"

}


resource "aws_instance" "puppet_master" {
#  ami           = "ami-e41b618b"
  ami           = "ami-c998b6b2"
  instance_type = "${var.modname}"
#  key_name = "docker key"
  key_name = "terra"
  vpc_security_group_ids = ["${var.awssecgp}"]
  subnet_id = "${var.awssub}"
  tags {


      Name = "puppet_master"

  }

  user_data = "${data.template_file.bootstrap.rendered}"


}

