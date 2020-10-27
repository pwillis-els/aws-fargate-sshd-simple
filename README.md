# About

This Terraform submodule will use the `aws-fargate-simple` module to deploy a container with a command that will run `sshd`, so you can ssh into whatever container you would normally use with Fargate.

This can be used to deploy a simple Bastion server, a container for working remotely from, to run deploys for your terraformcontrol repos, etc.

# Usage

Create the file `main.tf`:
```hcl
provider "aws" {
  profile   = "my-aws-profile"
  region    = "us-east-1"
}

module "fargate-service-sshd-simple" {
  source = "git::ssh://git@github.com/pwillis-els/aws-fargate-sshd-simple.git?ref=1.1"

  aws_account_id =   "1234567890"

  region =           "us-east-1"
  vpc_id =           "vpc-000000000000000"
  subnet_ids =       [ "subnet-0000000000000", "subnet-000000000001" ]

  ecr_container =    "my-container-name:latest"

  # or instead, comment the above line and uncomment the following:
  #container_image   =   "docker.io/alpine:latest"

  ssh_public_key    = "ssh-rsa AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=="
}
```

```bash
# Deploy the infrastructure
$ terraform plan
$ terraform apply

# If you decided to use the 'ecr_container' registry above,
# Push your Docker container to the new ECR repository.
$ aws ecr get-login-password \
    --region $AWS_REGION \
    | docker login \
        --username AWS \
        --password-stdin \
        $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com

$ docker tag \
    my-container:latest \
    $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/my-ecr-container-name:latest

# Wait a bit and the Fargate service will eventually pull the container and start a task.
# Check the Fargate service status and logs for errors.
```
