# Image resize on the fly AWS Lambda function with Serverless and Node.js

A simple Serverless service for creating an image resize-on-the-fly function with AWS Lambda. For Sharp to work correctly it must be installed in the same environment the production is running in. Because AWS Lambda is running on Amazon Linux it must be installed on the same system.

For this purpose we're using Docker to spin up a container, install the Serverless Framework and deploy the function from inside the container.

This service will deploy both the AWS Lambda function and AWS S3 bucket from where the images will be grabbed, resized and put back.

## Getting Started (Ubuntu-based Linux Systems)

These instructions will get you up and running. See deployment for notes on how to deploy the project on a live system.

#### Clone to your local machine:

```bash
$ git clone https://github.com/adnanrahic/serverless-docker-image-resize.git
```

#### Change into the cloned dir:
```bash
$ cd serverless-docker-image-resize
```

#### Install Docker and docker compose:

1. Install Docker
```bash
$ curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
$ sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
$ sudo apt-get update
$ apt-cache policy docker-ce
$ sudo apt-get install -y docker-ce
```
After typing the command:
```bash
$ sudo systemctl status docker
```
You should see the service is running.
```bash
Output
● docker.service - Docker Application Container Engine
   Loaded: loaded (/lib/systemd/system/docker.service; enabled; vendor preset: enabled)
   Active: active (running) since Sun 2016-05-01 06:53:52 CDT; 1 weeks 3 days ago
     Docs: https://docs.docker.com
 Main PID: 749 (docker)
```

2. Install Docker Compose
```bash
$ sudo curl -L https://github.com/docker/compose/releases/download/1.21.2/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
$ sudo chmod +x /usr/local/bin/docker-compose
$ docker-compose -v
```
This will print the installed version:
```bash
Output
docker-compose version 1.21.2, build a133471
```

All dependencies are installed. Now, deployment is a breeze.

## Deployment

### Configure secrets

#### 1. `secrets.json`

The `deploy.sh` script will autogenerate this file. No need to touch it at all.

#### 2. `secrets.env`

Add your secret keys and configuration variables here.
```env
SLS_KEY=XXX
SLS_SECRET=YYY
STAGE=dev
REGION=us-east-1
BUCKET=images.your-domain.com
```

### Run Docker Compose
```bash
$ docker-compose up --build
```
This will build the image, create a container, run the `deploy.sh` script inside the container and deploy all the resources.

The command line will log out the service endpoints and all info. What's important to note is the bucket name and URL you need to access your images. Check out [Usage](#usage).

## Usage

After the service has been deployed, you will receive a bucket endpoint. You will add a query parameter to it in order to tell it how to resize the image. The bucket will behave as a public website.

Let's upload an image so we have something to work with.
```bash
$ aws s3 cp --acl public-read IMAGE_NAME.jpg s3://BUCKET
```

Example 1:
```
http://BUCKET.s3-website.REGION.amazonaws.com/420x360/IMAGE_NAME.jpg
```

Or you can access the lambda function directly.

Example 2:
```
https://LAMBDA_ID.execute-api.REGION.amazonaws.com/dev/resize?key=420x360/IMAGE_NAME.jpg
```

This will resize the image in the fly and send you back the resized image while storing it for further reference.

## Credits
The original tutorial for resizing S3 images I followed can be found [here](https://aws.amazon.com/blogs/compute/resize-images-on-the-fly-with-amazon-s3-aws-lambda-and-amazon-api-gateway/)!
