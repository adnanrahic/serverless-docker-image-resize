FROM amazonlinux

# Create deploy directory
WORKDIR /deploy

# Install system dependencies
RUN yum -y install gcc-c++
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs

# Install serverless
RUN npm install -g serverless

# HERE'S WHERE YOU SHOULD
# REPLACE `XYZ` WITH YOUR KEYS
RUN sls config credentials --provider aws --key XYZ --secret XYZ


# COPY package.json .
COPY package.json ./

# Install app dependencies
RUN npm install

# Copy source
COPY . .