# docker-eks

Build, test and deploy the application to Elastic kubernetes Service (EKS) while learning deployment workflows using github CICD. 

# Tools
- ECR- Docker images repository to hold the images built
- Docker - for containerizng the express app
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

