data "aws_eks_cluster" "cluster" {
  name = module.my-cluster.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.my-cluster.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
  load_config_file       = false
  version                = "~> 1.9"
}

module "my-cluster" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "sfia2-production2.1"
  cluster_version = "1.14"
  subnets         = ["subnet-c08218ba", "subnet-d496c8bd", "subnet-f419b0b8"]
  vpc_id          = "vpc-e97c2881"

  worker_groups = [
    {
      instance_type = "t2.small"
      asg_max_size  = 3
    }
  ]
}
