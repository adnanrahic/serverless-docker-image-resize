FROM amazonlinux

# Create deploy directory
WORKDIR /deploy

# Install system dependencies
RUN yum -y install make gcc*
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs

# Install serverless
RUN npm install -g serverless

# Copy source
COPY . .

# Install app dependencies
RUN cd /deploy/functions && npm i --production && cd /deploy

#  Run deploy script
CMD ./deploy.sh ; sleep 2m