
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "eks-vpc"
  cidr = "10.0.0.0/16"

  azs                = ["eu-central-1a", "eu-central-1b"]
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24"]
  enable_nat_gateway = false
  enable_vpn_gateway = false

  # This setting is required for EKS nodes to receive a public IP address
  map_public_ip_on_launch = true


  tags = {
    "project" = "ci-cd-eks"
  }
}

# This creates the EKS cluster and a managed node group.
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.1.5"

  endpoint_public_access  = true # allow API access from internet
  endpoint_private_access = true

  name               = "my-express-app-eks"
  kubernetes_version = "1.29"

  vpc_id                   = module.vpc.vpc_id
  subnet_ids               = module.vpc.public_subnets
  control_plane_subnet_ids = module.vpc.public_subnets

  # Configure the managed node group
  eks_managed_node_groups = {
    express_app_nodes = {
      min_size       = 1
      max_size       = 2 # Changed max_size to allow for scaling
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }

  tags = {
    "project" = "ci-cd-eks"
  }
}

# data "aws_eks_cluster" "this" {
#   name = module.eks.cluster_name
# }
# data "aws_eks_cluster_auth" "this" {
#   name = module.eks.cluster_name
# }


provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_token

}

# Kubernetes Deployment for the Express app
resource "kubernetes_deployment" "express_app" {
  metadata {
    name      = "express-app-deployment"
    namespace = "default"
  }
  spec {
    replicas = 2
    selector {
      match_labels = {
        app = "express-app"
      }
    }
    template {
      metadata {
        labels = {
          app = "express-app"
        }
      }
      spec {
        container {
          name  = "express-app"
          image = "${aws_ecr_repository.express_app_repo.repository_url}:latest" # Replace with your actual Docker image name
          port {
            container_port = 8080
          }
        }
      }
    }
  }
}

# Kubernetes Service for the Express app
resource "kubernetes_service" "express_app_service" {
  metadata {
    name      = "express-app-service"
    namespace = "default"
  }
  spec {
    selector = {
      app = "express-app"
    }
    port {
      port        = 80
      target_port = 8080
    }
    type = "LoadBalancer"
  }
}

# add ecr repo to store the images we create

resource "aws_ecr_repository" "express_app_repo" {
  name                 = "express-app-repo"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = "ExpressAppECR"
  }
}

