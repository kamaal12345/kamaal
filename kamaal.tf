{
  "AWSTemplateFormatVersion" : "2010-09-09",

  "Description" : "AWS CloudFormation Sample Template VPC_EC2_Instance_with_EIP_and_Security_Group: Sample template showing how to create an instance with an Elastic IP address and a security group in an existing VPC. It assumes you have already created a VPC. **WARNING** This template creates an Amazon EC2 instance. You will be billed for the AWS resources used if you create a stack from this template.",

  "Parameters" : {

    "KeyName" : {
      "Description" : "Name of and existing EC2 KeyPair to enable SSH access to the instance",
      "Type" : "String"
    },

    "VpcId" : {
      "Type" : "String",
      "Description" : "VpcId of your existing Virtual Private Cloud (VPC)"
    },

    "SubnetId" : {
      "Type" : "String",
      "Description" : "SubnetId of an existing subnet in your Virtual Private Cloud (VPC)"
    },
    "SSHLocation" : {
      "Description" : " The IP address range that can be used to SSH to the EC2 instances",
      "Type": "String",
      "MinLength": "9",
      "MaxLength": "18",
      "Default": "0.0.0.0/0",
      "AllowedPattern": "(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})\\.(\\d{1,3})/(\\d{1,2})",
      "ConstraintDescription": "must be a valid IP CIDR range of the form x.x.x.x/x."
    }  
  },

  "Mappings" : {
    "RegionMap" : {
      "us-east-1"      : { "AMI" : "ami-7f418316" },
      "us-west-1"      : { "AMI" : "ami-951945d0" },
      "us-west-2"      : { "AMI" : "ami-16fd7026" },
      "eu-west-1"      : { "AMI" : "ami-24506250" },
      "sa-east-1"      : { "AMI" : "ami-3e3be423" },
      "ap-southeast-1" : { "AMI" : "ami-74dda626" },
      "ap-southeast-2" : { "AMI" : "ami-b3990e89" },
      "ap-northeast-1" : { "AMI" : "ami-dcfa4edd" }
    }
  },

  "Resources" : {

    "IPAddress" : {
      "Type" : "AWS::EC2::EIP",
      "Properties" : {
        "Domain" : "vpc",
        "InstanceId" : { "Ref" : "Ec2Instance" }
      }
    },

    "InstanceSecurityGroup" : {
	# checkov:skip=BC_AWS_NETWORKING_31: ADD REASON
      "Type" : "AWS::EC2::SecurityGroup",
      "Properties" : {
        "VpcId" : { "Ref" : "VpcId" },
        "GroupDescription" : "Enable SSH access via port 22",
        "SecurityGroupIngress" : [ {"IpProtocol" : "tcp", "FromPort" : "22", "ToPort" : "22", "CidrIp" : { "Ref" : "SSHLocation"}} ]
      }
    },

    "Ec2Instance" : {
      "Type" : "AWS::EC2::Instance",
      "Properties" : {
        "ImageId" : { "Fn::FindInMap" : [ "RegionMap", { "Ref" : "AWS::Region" }, "AMI" ]},
        "SecurityGroupIds" : [{ "Ref" : "InstanceSecurityGroup" }],
        "SubnetId" : { "Ref" : "SubnetId" },
        "KeyName" : { "Ref" : "KeyName" }
      }
    }
  },

  "Outputs" : {
    "InstanceId" : {
      "Value" : { "Ref" : "Ec2Instance" },
      "Description" : "Instance Id of newly created instance"
    },

    "IPAddress" : {
      "Value" : { "Ref" : "IPAddress" },
      "Description" : "Public IP address of instance"
    }
  }
}
