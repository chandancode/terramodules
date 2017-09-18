output "private_subnet_id" {
  value = "${aws_subnet.private_1_subnet_ap_south_1b.id}"
}

output "public_subnet_id" {
  value = "${aws_subnet.public_subnet_ap_south_1a.id}"
}


output "security_group_id" {
  value = "${aws_security_group.FrontEnd.id}"
}
