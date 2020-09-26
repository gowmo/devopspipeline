output "instance_ips" {
  value = ["${aws_instance.default.*.public_ip}"]
}

data "template_file" "inventory" {
    template = "${file("./inventory.tmpl")}"

    vars = {
       aws_public_ip = "${aws_instance.default.*.public_ip[0]}"
    }
}

resource "local_file" "save_inventory" {
  content  = "${data.template_file.inventory.rendered}"
  filename = "./myhost"
}

