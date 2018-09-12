cd /deploy

# REPLACE `XYZ` WITH YOUR KEYS
sls config credentials --provider aws --key ${SLS_KEY} --secret ${SLS_SECRET} --profile serverless-admin

# cd into functions dir
cd /deploy/functions

# Deploy code
sls deploy

# find and replace the service endpoint
stage=${STAGE}
if [ -z ${stage+dev} ]; then echo "stage is unset"; else echo "stage is set to '$stage'"; fi

sls info -v | grep ServiceEndpoint > domain.txt
sed -i 's@ServiceEndpoint:\ https:\/\/@@g' domain.txt
sed -i "s@/${STAGE}@@g" domain.txt
domain=$(cat domain.txt)
sed -i "s@REPLACE_ME@$domain@g" ../secrets.json
rm domain.txt

cd /deploy/bucket

# Deploy bucket config
sls deploy

# Deploy domain
# sls create_domain

echo "------------------"
echo "Service deployed. Press CTRL+C to exit."