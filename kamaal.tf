# Define the AWS provider
provider "aws" {
  region = "us-east-1"
}

# Create a new EC2 instance
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"
  key_name      = "my-key-pair"
  security_groups = ["my-security-group"]
  tags = {
    Name = "example-instance"
  }
}

# Store the state file remotely in a GitHub repository
terraform {
  backend "s3" {
    bucket         = "my-terraform-state"
    key            = "ec2.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Output the public IP address of the EC2 instance
output "public_ip" {
  value = aws_instance.example.public_ip
}
