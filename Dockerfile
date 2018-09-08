FROM amazonlinux

# Create deploy directory
WORKDIR /deploy

# Install system dependencies
RUN yum -y install make gcc*
RUN curl --silent --location https://rpm.nodesource.com/setup_8.x | bash -
RUN yum -y install nodejs

# Install serverless
RUN npm install -g serverless

# COPY package.json .
COPY package.json ./

# Install app dependencies
RUN npm install

# Copy source
COPY . .

CMD ./deploy.sh ; sleep infinity