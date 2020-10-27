variable "security_groups" {
  description = "The security groups to apply to your Fargate service"
  default = []
}

variable "subnet_ids" {
  description = "The subnet IDs to deploy your Fargate service into"
  #default = []
}

variable "vpc_id" {
  description = "The VPC ID to deploy security groups into"
}

variable "region" {
  description = "The AWS region"
}

variable "aws_account_id" {
  description = "The AWS account ID"
  type = string
}

variable "ecr_container" {
  description = "The name:tag of a container to deploy to ECR (that will be our bastion service)"
  default = "bastion-container:latest"
}

variable "container_image" {
  description = "Rather than specify just the var.ecr_container value, if you set this, this will be the full Docker image that Fargate will pull for your tasks. This defaults to an ECR URL that this module creates based on the var.ecr_container variable."
  default = ""
}

variable "container_port" {
  description = "The TCP port of the sshd server listening on the Fargate container"
  default = 22
}

variable "sg_ingress_cidr" {
  description = "The CIDRs allowed to connect to the var.container_port of the Fargate task"
  default = [ "10.0.0.0/8" ]
}

variable "ssh_public_key" {
  description = "The public SSH key to tell the bastion server to accept. Technically this can probably be multiple keys if you can embed newlines in this string."
}

variable "cluster_name" {
  description = "The name for the Fargate cluster"
  default = "bastion-cluster"
}

variable "sshd_entrypoint_remote_script" {
  description = "This URL will be downloaded by Curl and executed when the Fargate container starts. It provides all the instructions for setting up sshd, and runs it in the foreground. You can create your own script and provide your own URL in this variable."
  default = "https://gist.githubusercontent.com/pwillis-els/446f00b6df5caf033dd86ae951eb3938/raw/9568b101c7ab1a292b5ce024884e30c55d2a5bb8/sshd-entrypoint.sh"
}
