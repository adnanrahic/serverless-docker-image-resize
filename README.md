# Image resize AWS Lambda function with Serverless and Node.js

This is a simple Serverless service for creating an image resize function with AWS Lambda. For Sharp to work correctly it must be installed in the same environment the production is running in. Because AWS Lambda is running on Amazon Linux it must be installed on the same system.

For this purpose we're using Docker to spin up a container, install serverless and deploy the function from inside the container.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

Clone to your local machine:
```
git clone https://github.com/adnanrahic/serverless-docker-image-resize.git
```

Change into the cloned dir:
```
cd serverless-docker-image-resize
```

Install required dependencies:

1. Install Docker
```
$ sudo apt-get update
$ sudo apt-get install docker-ce
```

2. Install Docker Compose
```
sudo curl -o /usr/local/bin/docker-compose -L "https://github.com/docker/compose/releases/download/1.16.1/docker-compose-$(uname -s)-$(uname -m)"
sudo chmod +x /usr/local/bin/docker-compose
docker-compose -v
```

This will print the installed version:
Output
docker-compose version 1.16.1, build e12f3b9