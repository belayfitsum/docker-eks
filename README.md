# Cloud Infrastructure Automation: Terraform | AWS | Docker | GitHub CI/CD | Kubernetes

Build, test and deploy a small express application to Elastic kubernetes Service (EKS) while learning deployment workflows using github CICD. 

# Project 

I began by setting up an S3 backend for Terraform and provisioning an ECR repository as the initial step. I then added EKS cluster creation using the official AWS EKS module, which also installs the necessary dependencies for the cluster to run.

However, I encountered issues during node creation since some resources needed to be in place before the module could complete successfully. To work around this, I explored an alternative approach. The original setup has been commented out and kept in the codebase for future development.

# New setup

Provisioned the EKS cluster using eksctl, which made the process much simpler. eksctl deploys AWS CloudFormation stacks that automatically create and configure all required resources, such as worker nodes, VPC, subnets, IAM roles, and permissions.

While I had Administrator access to the deployment environment (AWS), I followed best practices by creating a dedicated CI/CD user with only the minimum required permissions instead of relying on admin credentials. This adds an extra layer of security and ensures least-privilege access. The CICD user has only needed privillages to run pipline jobs. 

# Prerequisites

- AWS account and IAM admin access (for initial setup)

- eksctl and kubectl installed

- terraform installed

- Docker installed locally

### Create EKS Cluster with eksctl  

This command will create EKS cluster in **us-east-1** with two `t2.micro` worker nodes:  

eksctl create cluster \
  --name k8-express-app-cluster \
  --region us-east-1 \
  --nodegroup-name linux-nodes \
  --node-type t2.micro \
  --nodes 2

- Save the file in the project and push it to github. The pipline triggered with push will walk through each job using a gihb hosted runners and perform each steps as dictated in the github workflows file. 

# Tools/environments
- ECR- Docker images repository to hold the images built
- Docker - for containerizng the express app
- Kubernetes- to deployment environment for the containerized app 
- Terraform- IaC tool to provision the base infrastructure such as ECR repository, VPC and EKS clusters
- Github- for version control and deployment to AWS- CICD

# Development & Deployment Workflow

- Create a feature branch and make your changes.

- Push the branch to GitHub and open a pull request to merge into the main branch.

- GitHub Actions automatically pulls the code and runs tests.

- Once tests pass, merge the code into main.

- GitHub Actions (CI/CD) then builds the Docker image, pushes it to ECR, and deploys it to the EKS cluster. 

# Notes

GitHub Actions now uses the dedicated CICD user to run pipeline jobs.
When new permissions are required (for example, to access EC2, EKS, or other AWS services), switch temporarily to the admin user to set up those permissions.

After the policies are updated, you can safely switch back to the CICD user, ensuring pipelines continue running with the principle of least privilege.

# Future Improvments

- 
