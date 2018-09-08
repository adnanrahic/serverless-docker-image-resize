cd /deploy

# REPLACE `XYZ` WITH YOUR KEYS
sls config credentials --provider aws --key ${SLS_KEY} --secret ${SLS_SECRET}

# Deploy code
sls deploy

# find and replace the service endpoint
sls info -v | grep ServiceEndpoint > serviceEndpoint.txt
sed -i 's/ServiceEndpoint:\ //g' serviceEndpoint.txt
serviceEndpoint=cat serviceEndpoint.txt
# TODO: sed replace DOMAIN in secrets with the $serviceEndpoint var
# code here...

# Deploy domain
sls create_domain

# Deploy code again
sls deploy