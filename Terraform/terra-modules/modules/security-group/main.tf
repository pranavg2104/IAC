resource "aws_security_group" "sg" {
    vpc_id = var.vpc_id

    name = "${var.app_name}-sg"
    
    tags = {
      Name = "${var.app_name}-sg"
    }
}

resource "aws_vpc_security_group_ingress_rule" "http" {
    security_group_id = aws_security_group.sg.id
    ip_protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
    security_group_id = aws_security_group.sg.id
    ip_protocol = "tcp"
    from_port = 22
    to_port = 22
    cidr_ipv4 = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "internet" {
    security_group_id = aws_security_group.sg.id
    ip_protocol = "-1"
    cidr_ipv4 = "0.0.0.0/0"
}