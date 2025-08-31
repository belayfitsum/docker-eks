# docker-eks

build, test and deploy the node application with kubernetes while learning deployment workflows 

# Then we dockerize

- listing all the dependencies of the app as put in package json dependencies and the command we want to run

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

