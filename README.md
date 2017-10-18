# Image resize AWS Lambda function with Serverless and Node.js

This is a simple Serverless service for creating an image resize function with AWS Lambda. For Sharp to work correctly it must be installed in the same environment the production is running in. Because AWS Lambda is running on Amazon Linux it must be installed on the same system.

For this purpose we're using Docker to spin up a container where the

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

Clone to your local machine:
```
git clone https://github.com/adnanrahic/boilerplate-api.git
```

Change into the cloned dir:
```
cd boilerplate-api
```

Install required modules:
```
npm install
```