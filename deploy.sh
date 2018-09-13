#!bin/bash

# variables
stage=${STAGE}
region=${REGION}
secrets='../secrets/secrets.json'

cd /deploy

# REPLACE `XYZ` WITH YOUR KEYS
sls config credentials --provider aws --key ${SLS_KEY} --secret ${SLS_SECRET} --profile serverless-admin

# cd into functions dir
cd /deploy/functions

# Deploy code
sls deploy

# find and replace the service endpoint
if [ -z ${stage+dev} ]; then echo "Stage is unset."; else echo "Stage is set to '$stage'."; fi

sls info -v | grep ServiceEndpoint > domain.txt
sed -i 's@ServiceEndpoint:\ https:\/\/@@g' domain.txt
sed -i "s@/$stage@@g" domain.txt
domain=$(cat domain.txt)
sed "s@/.execute-api.$region.amazonaws.com@@g" domain.txt > id.txt
id=$(cat id.txt)
rm domain.txt
rm id.txt

# replace when never replaced before
sed -i "s@REPLACE_ME@$domain@g" $secrets

# replace when deployment needs updating
regexp="s@\"DOMAIN\":\ \"(.*)\.execute-api.$region.amazonaws.com\"@\"DOMAIN\":\ \"$id.execute-api.$region.amazonaws.com\"@g"
# sed -i -E $regexp $secrets

# copy replace 'sed without -i'
tmp_secrets='/tmp/secrets.json'
sed -E $regexp $secrets > $tmp_secrets && cp $tmp_secrets $secrets
rm $tmp_secrets

cd /deploy/bucket

# Deploy bucket config
sls deploy

# Deploy domain
# sls create_domain

echo "------------------"
echo "Service deployed. Press CTRL+C to exit."

# gmyn5pmj4j.execute-api.us-east-1.amazonaws.com
