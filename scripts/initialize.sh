#!/bin/bash

# check if CLOUDFLARE_ZONE_ID and CLOUDFLARE_API_TOKEN is set
if [ -z "$CLOUDFLARE_ZONE_ID" ] || [ -z "$CLOUDFLARE_API_TOKEN" ]; then
  echo "CLOUDFLARE_ZONE_ID or CLOUDFLARE_API_TOKEN are not set"
  exit 1
else
  echo "CLOUDFLARE_ZONE_ID and CLOUDFLARE_API_TOKEN are set"
fi


# check cf-terraforming is installed
if [ ! -x "$(command -v cf-terraforming)" ]; then
  echo "cf-terraforming is not installed"
  exit 1
else
  echo "cf-terraforming is installed"
fi

cd terraform

# set API Token in terraform.tfvars
echo "create terraform.tfvars"
echo "cloudflare_api_token = \"$CLOUDFLARE_API_TOKEN\"" > terraform.tfvars

# initialize terraform
echo "initialize terraform"
terraform init

# generate .tf file from existing dns records
echo "generate .tf file from existing dns records"
cf-terraforming generate --resource-type "cloudflare_record" -z $CLOUDFLARE_ZONE_ID > records.tf
cf-terraforming import --resource-type "cloudflare_record" -z $CLOUDFLARE_ZONE_ID > import.sh

# delete unchangable records to manage mail servers in Cloudflare's Email Routing
echo "delete unchangable records to manage mail servers in Cloudflare's Email Routing"
python3 ../scripts/delete_cloudflare_mx_records.py

# import existing dns records to manage them with terraform
echo "import existing dns records to manage them with terraform"
bash import.sh

# apply changes
echo "apply changes"
terraform apply -auto-approve
