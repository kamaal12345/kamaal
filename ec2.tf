##Random 
resource "random_pet" "sg" {}

##AWS VPC
resource "aws_vpc" "demo" {
	cidir_block = "172.16.0.0/16"

  tags ={
	Name = "vpc-quickcloudpocs"
  }
}

##AWS VPC Subnet

resource "aws_subnet" "demo1" {
  vpc_id  = aws_vpc.demo1.id
  cidir_block = "172.16.10.0/24"

  tags = {
   Name = "subnet-quickcloudpocs"
 }
}

## AWS INTERFACE 
 resource "aws_network_interface" "demo1" {
 subnet_id  =aws_subnet.demo1.id
 private_ips =  ["172.16.1.200"]

 tags = {
  Name = "Kamaal subnet"
 }

}

##AWS Security Group 

resource "aws_security_group" "demo1" {
 name = "${random_pet.sg.id}-sg"
 vpc_id  =aws_vpc.demo1.id
 ingress {
	from_port  = 8080
	to_port    = 8080
	protocol   = "tcp"
	cidir_blocks =["0.0.0.0/0"]
  }
}

##AWS EC2

 resource "aws_instance" "demo1" {

 	 ami    =  "ami-00c39f71452c08778" # us-ease-1
	  instance_type = "t2.micro"

 	network_interface {
	network_interface_id = aws_interface.demo1.id
	 device_index     = 0
  }
}
		

