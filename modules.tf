module "fargate-service-simple" {
  source = "git::ssh://git@github.com/pwillis-els/aws-fargate-simple.git?ref=1.1"

  aws_account_id    =   var.aws_account_id
  region            =   var.region
  vpc_id            =   var.vpc_id
  subnet_ids        =   var.subnet_ids
  security_groups   =   var.security_groups
  sg_ingress_cidr   =   var.sg_ingress_cidr

  ecr_container     =   var.ecr_container
  container_image   =   var.container_image
  container_taskdef =   local.container_taskdef
  container_port    =   var.container_port
  cluster_name      =   var.cluster_name

}
