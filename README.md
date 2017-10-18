# Image resize AWS Lambda function with Serverless and Node.js

This is a simple Serverless service for creating an image resize function with AWS Lambda. For Sharp to work correctly it must be installed in the same environment the production is running in. Because AWS Lambda is running on Amazon Linux it must be installed on the same system.

For this purpose we're using Docker to spin up a container, install serverless and deploy the function from inside the container.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

#### Up and running on Debian based Linux Systems

Clone to your local machine:
```
git clone https://github.com/adnanrahic/serverless-docker-image-resize.git
```

Change into the cloned dir:
```
cd serverless-docker-image-resize
```

Install Serverless globally:
```
sudo npm install -g serverless
```

Install required dependencies:
```
npm install
```

Add your AWS account keys in the `Dockerfile`. Change line 16 to accept proper keys to connect to your AWS account.

Emulate AWS Lambda and API Gateway locally:
```
serverless offline start
```

## Deployment

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
```
Output
docker-compose version 1.16.1, build e12f3b9
```

3. Run Docker Compose
```
$ docker-compose up
```
This will build the image and create a container.

To list all images:
```
$ docker images
```

To list all containers:
```
$ docker ps -a
```

4. Run the container
List all containers and note the `containerid` of the container which was created by the command above.

```
$ docker run -rm -ti -d <containerid> sh
```

Replace `<containerid>` with the id you noted above.

5. Connect to the container

Now you need to ssh into the container to access its command line interface.
```
$ docker attach <containerid>
```

You will se the shell interface change. Now you're interacting with the container directly.

6. Deploy the function

Enter the `/deploy` directory to deploy the function
```
$ cd /deploy

$ serverless deploy -v
```