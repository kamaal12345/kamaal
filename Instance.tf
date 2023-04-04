# Define the AWS provider
- provider: "aws" {
  region = "us-east-1"
  access_key = "AKIAVWY4KPJQKK5YWDXL"
  secret_key = "0XIQaE6pKkL9wj12tg7mkngX4yC6DpFBQdlcdtx3"
}

# Create a new EC2 instance
-  resource:  "aws_instance" "example" {
    ami           = "ami-00c39f71452c08778"
    instance_type = "t2.micro"
    key_name      = "my-key-pair"
    vpc_security_group_ids = ["${aws_default_vpc.default.default_security_group_id}"]
    subnet_id     = "${aws_default_vpc.default.subnet_ids[0]}"
 - tags:  = {
    Name = "example-instance"
  }
}
