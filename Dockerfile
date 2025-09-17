# Specify a base image. Pulled from node repository and an alpine tag 
FROM node:alpine

WORKDIR /usr/app

# Install node dependencies- package json must come before npm install
COPY ./package.json ./

# install dependencies to the container
RUN npm install

# copy everything else 
COPY ./ ./

# Default command
CMD ["npm", "start"]
