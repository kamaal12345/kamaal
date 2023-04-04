provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

resource "aws_instance" "kamaal" {
  ami           = "ami-00c39f71452c08778"
  instance_type = "t2.micro"
   network_interface {
    network_interface_id = aws_network_interface.foo.id
    device_index         = 0
  }

  credit_specification {
    cpu_credits = "unlimited"
  }
}

 AutoScalingConfig:
    Type: AWS::AutoScaling::LaunchConfiguration
    Properties:
      ...
      BlockDeviceMappings:
      - DeviceName: "/dev/sdk"
+       Ebs:
          ...
+         Encrypted: true
      - DeviceName: "/dev/sdf"
        Ebs:
            Encrypted: false
            - DeviceName: "/dev/sdc"
 VirtualName: ephermal
 






