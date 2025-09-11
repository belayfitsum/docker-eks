# Cloud Infrastructure Automation: Terraform | AWS | Docker | GitHub CI/CD | Kubernetes

Build, test and deploy a small express application to Elastic kubernetes Service (EKS) while learning deployment workflows using github CICD. 

# Project 

I began by setting up an S3 backend for Terraform and provisioning an ECR repository as the initial step. I then added EKS cluster creation using the official AWS EKS module, which also installs the necessary dependencies for the cluster to run.

However, I encountered issues during node creation since some resources needed to be in place before the module could complete successfully. To work around this, I explored an alternative approach. The original setup has been commented out and kept in the codebase for future reference.

# New setup

Provisioned the EKS cluster using eksctl, which made the process much simpler. eksctl deploys AWS CloudFormation stacks that automatically create and configure all required resources, such as worker nodes, VPC, subnets, IAM roles, and permissions.

While I had Administrator access to the deployment environment (AWS), I followed best practices by creating a dedicated CI/CD user with only the minimum required permissions instead of relying on admin credentials. This adds an extra layer of security and ensures least-privilege access. The CICD user has only needed privillages to run pipline jobs. 

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

# Port mapping
forwarding incoming traffic to the container from our computer on a specific port.
<docker run -p 8080:8080 a56df1d12a4d>

# Development workflow

Feature branch > Make changes
push to github and create pull request to merge with master branch
<the github CI pull the code and run tests>
Then code is merged to master. 
Then raise merge rewuest to production branch
Github cicd pull the code and run tests
Then finally deploy it to deployment server

# Mitigating errors in tf apply

Deploy the cluster first bcuse for some of the resources that should be first in place, like quering it.
< terrfaform apply -taget=module.eks>

Once the cluster exists

<terraform apply>

Anoter option:

Removing k8 creation from terraform and use kubectl cli to deploy ek8 cluster
Only ecr repo creatoon handled with terraform

[Deployment] ---> creates ---> [Pods] (with label app=express-app)
                                  ↑
                                  |
                             [Service]
                         (routes traffic to pods)
                                  ↑
                                  |
                          [LoadBalancer/Ingress]
                              (exposes externally)

# Notes

GitHub Actions now uses the dedicated CICD user to run pipeline jobs.
When new permissions are required (for example, to access EC2, EKS, or other AWS services), switch temporarily to the admin user to set up those permissions.

After the policies are updated, you can safely switch back to the CICD user, ensuring pipelines continue running with the principle of least privilege.
