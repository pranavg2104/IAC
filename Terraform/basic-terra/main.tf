# Create Security Groups

resource "aws_security_group" "sg"{
    name = "Basic Security Group"
    description = "Allow Port 80 for HTTP"

    tags = {
        Name = "basic-sg"
    }
}

# Allow all traffic from instance to outside
resource "aws_vpc_security_group_egress_rule" "vpc"{
    security_group_id = aws_security_group.sg.id
    cidr_ipv4 = "0.0.0.0/0"
    ip_protocol = "-1"
}

# Allow TCP traffic from world on port 80 to instance  
resource "aws_vpc_security_group_ingress_rule" "vpc"{
    security_group_id = aws_security_group.sg.id
    cidr_ipv4 = "0.0.0.0/0"
    from_port = 80
    ip_protocol = "tcp"
    to_port = 80
}

#Create EC2 instance with Security group attached
resource "aws_instance" "web"{
    ami = "ami-0dee22c13ea7a9a67"
    instance_type = "t3.micro"
    security_groups = [aws_security_group.sg.name]
    associate_public_ip_address = true

    user_data = file("userdata.sh")

    tags = {
        Name = "First Instance"
    }
}

#get the ec2 public IP for nginx check
output "instance_public_ip"{
    value = aws_instance.web.public_ip
    description = "Public IP of the instance"
}