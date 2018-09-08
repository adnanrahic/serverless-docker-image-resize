cd /deploy

# REPLACE `XYZ` WITH YOUR KEYS
sls config credentials --provider aws --key ${SLS_KEY} --secret ${SLS_SECRET}

# Deploy code
sls deploy

# Deploy domain
sls create_domain

# Deploy code again
sls deploy