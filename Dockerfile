# Specify a base image
FROM node:18-alpine

WORKDIR /usr/app

# Install node dependencies- package json must come before npm install
COPY ./package.json ./

# install dependencies to the container
RUN npm install

# copy everything else 
COPY ./ ./

# Default command
CMD ["npm", "start"]
