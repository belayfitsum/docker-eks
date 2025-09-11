# docker-eks

Build, test and deploy the application to Elastic kubernetes Service (EKS) while learning deployment workflows using github CICD. 

# Project 

I started with setting up s3 backend for terraform and provisioning the ECR repository at the gate go. I also added eks creation using aws-module for eks which installs all dependencies required for the eks to run. However deploying the eks cluster  has run into issues with the nodes creation as some of the resources needs to be inplace before the module creation is complete. For that reason I switched for a second option. I commented out the old setup for future references.

# New setup

- Provision eks using eksctl. This was much easier to get started because eksctl ddeploy AWS Cloudformation
stacks which contains everything , such as worker nodes, ,VPC, Subnets,IAM permissions and roles etc. Even thoughI have an Administrator role to the deployment environment i.e able to do whatever on ECR, EKS etc, it is a recommended practice to create a dedicated user for the CICD pipline with only enough permission. 
<eksctl create cluster --name k8-express-app-cluster --region eu-central-1 --nodegroup-name linux-nodes --node-type t2.micro --nodes 2>

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

Now github secrets use the new cicd user responsible to run pipeline jobs. However when there is a need to add permissions to access ec2, k8 or anything else, it should be switched to the admin usr credentials to setup permissions and switch back again. 
It is always possible to swap to CICD user when the necessary permissions are set to it by admin user.
