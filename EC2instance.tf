
module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  count = 1
  ami   = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
  
  tags = {
    Name = "my-ec2-instance"
  }
}
