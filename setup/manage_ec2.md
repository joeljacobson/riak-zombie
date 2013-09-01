
### EC2 Instance Management

1.) Download EC2 Command line tools - http://aws.amazon.com/developertools/351
2.) Configure http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/SettingUp_CommandLine.html


### Create Instances

`ec2-run-instances ami-ce7b6fba -k ricardomontalban -g riak-training -n <number of instances> -t m1.large`

### List Instances

`ec2-describe instances`

### Terminate Instances

`ec2-terminate instance <instance-id>`
