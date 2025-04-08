terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      
    }
  }

  backend "s3" {
    bucket  = "my-api-test-buck"
    key     = "infra.tfstate"
    region  = "eu-central-1"
    encrypt = true
  }
}

provider "aws" {
  region = "eu-central-1"
}
provider "kubernetes" {
  config_path = "~/.kube/config"
}

# Create a default VPC if it doesn't exist
resource "aws_default_vpc" "default_vpc" {
  tags = {
    Name = "eks_vpc"
  }
}

# Data source for availability zones
data "aws_availability_zones" "aws_availability_zones" {}

# Create subnets in AZ1 and AZ2
resource "aws_default_subnet" "subnet_az1" {
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[0]
}

resource "aws_default_subnet" "subnet_az2" {
  availability_zone = data.aws_availability_zones.aws_availability_zones.names[1]
}

# EKS Cluster Setup
module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "my-express-app-eks"
  cluster_version = "1.27"

  cluster_endpoint_public_access = true

  vpc_id                   = aws_default_vpc.default_vpc.id
  subnet_ids               = [aws_default_subnet.subnet_az1.id, aws_default_subnet.subnet_az2.id]
  control_plane_subnet_ids = [aws_default_subnet.subnet_az1.id, aws_default_subnet.subnet_az2.id]

  eks_managed_node_groups = {
    express_app_nodes = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}

# Security Group for EC2 (worker nodes)
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
    Name = "API_Security_Group"
  }
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
          image = "fitsena/web:latest"  # Replace with your actual Docker image name
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

# add ecr repo 

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

