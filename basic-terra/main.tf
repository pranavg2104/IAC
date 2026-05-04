resource "aws_security_group" "sg"{
    name = "Basic Security Group"
    description = "Allow Port 80 for HTTP"

    tags = {
        Name = "basic-sg"
    }
}

resource "aws_vpc_security_group_egress_rule" "vpc"{
    security_group_id = aws_security_group.sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

resource "aws_vpc_security_group_ingress_rule" "vpc"{
    security_group_id = aws_security_group.sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
}

resource "aws_instance" "web"{
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t3.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    associate_public_ip_address = true

    user_data = file("userdata.sh")

    tags = {
        Name = "First Instance"
    }
}

output "instance_public_ip"{
    value = aws_instance.web.public_ip
    description = "Public IP of the instance"
}