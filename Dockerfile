FROM amazonlinux

# Create build directory
WORKDIR /build

# Install system dependencies
RUN yum -y install gcc-c++
RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash -
RUN yum -y install nodejs

# Install serverless
RUN npm install -g serverless && \
    sls config credentials --provider aws --key xxx --secret xxx

# COPY package.json .
COPY package.json ./

# Install app dependencies
RUN npm install

# Copy source
COPY . .


# EXPOSE 3000
# CMD [ "sls", "offline", "start" ]

# docs
# $ docker-compose up
# $ docker run -rm -ti -d <containername> sh
# $ docker attach <containername>
# $ sls deploy -v