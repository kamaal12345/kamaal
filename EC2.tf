Resources:
  MyEC2Instance:
    Type: 'AWS::EC2::Instance'
    Properties:
      ImageId: ami-00c39f71452c08778
      InstanceType: t2.micro
      KeyName: my-key-pair
      SecurityGroupIds:
        - my-security-group
      Tags:
        - Key: Name
          Value: example-instance

