# Cloud Infrastructure Automation: Terraform | AWS | Docker | GitHub CI/CD | Kubernetes

Build, test and deploy a small express application to Elastic kubernetes Service (EKS) while learning deployment workflows using github CICD. 

### Infrastructure setup 

This project provisions infrastructure on AWS for running an Express.js application inside EKS (Elastic Kubernetes Service).
I tested two different approaches for cluster creation and management:

1. Using eksctl

    - Simpler CLI-driven setup.

    - Good for quick experimentation.

2. Using Terraform AWS EKS Module

    - Infrastructure defined as code (infra.tf).

    - Supports full lifecycle management of:

    - VPC

    - EKS cluster

    - Node groups

    - IAM roles and policies

    - ECR repositories

The GitHub Actions pipeline authenticates to AWS using assume-role.

The CICD IAM user (simple-web-app-usr) assumes an admin deployment role (AdminDeployRoleSimpleWeb) for Terraform.

This avoids storing admin credentials directly in GitHub secrets.

*** Notes- if you prefer to use eksctl , easier setup, comment out the eks module setup from the infrastructure part.

### Eksctl setup

Provisioned the EKS cluster using eksctl, which made the process much simpler. eksctl deploys AWS CloudFormation stacks that automatically create and configure all required resources, such as worker nodes, VPC, subnets, IAM roles, and permissions.

While I had Administrator access to the deployment environment (AWS), I followed best practices by creating a dedicated CI/CD user with only the minimum required permissions instead of relying on admin credentials. This adds an extra layer of security and ensures least-privilege access. The CICD user has only needed privillages to run pipline jobs. 

### Prerequisites

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

### Tools/environments

- ECR- Docker images repository to hold the images built
- Docker - for containerizng the express app
- Kubernetes- to deployment environment for the containerized app 
- Terraform- IaC tool to provision the base infrastructure such as ECR repository, VPC and EKS clusters
- Github- for version control and deployment to AWS- CICD

# Development & Deployment Workflow

- Create a feature branch[ticket numer as best prctice] and make your changes.

- Push the branch to GitHub and open a pull request to merge into the main branch.

- GitHub Actions automatically pulls the code and runs tests.

- Once tests pass, merge the code into main.

- GitHub Actions (CI/CD) then builds the Docker image, pushes it to ECR, and deploys it to the EKS cluster. 

### Notes

GitHub Actions now uses the dedicated CICD user to run pipeline jobs.
However when new permissions are required (for example, to access EC2, EKS, or other AWS services), switch temporarily to the admin user to set up/bootstrap those permissions. \
After the policies are updated, you can safely switch back to the CICD user, ensuring pipelines continue running with the principle of least privilege.\

 Or most prefrably  assumes an admin deployment role (AdminDeployRoleSimpleWeb) temporarily to perform an admin-level IAM task.\
 This can be clearly seen in the pipline job {terraform-infra-wf}, where The GitHub Actions pipeline first authenticates with a dedicated CI/CD IAM user, which then assumes an admin deployment role (AdminDeployRoleSimpleWeb) to provision infrastructure. 


    - name: Assume Admin Role \
      id: assume_role \
      uses: aws-actions/configure-aws-credentials@v3 \
      with: \
        role-to-assume: ${{ secrets.AWS_ADMIN_ROLE_ARN }} \
        role-session-name: terraform-admin \
        aws-region: ${{ secrets.AWS_REGION }} \

### Project cleanup

- Terraform
---terraform destroy\
- Kubernetes
---eksctl delete cluster --name XXX

