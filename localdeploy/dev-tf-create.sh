#!/bin/bash
export RED='\033[0;31m'
export YELLOW='\033[1;33m'
export GREEN='\033[0;32m'
export BLUE='\033[0;34m'
export PURPLE='\033[0;35m'
export CYAN='\033[0;36m'
export NC='\033[0m' # No Color

environment="dev"

#export ARM_CLIENT_ID="17470d69-eaf3-4e91-ae7c-b88af14c48a7"
export ARM_SUBSCRIPTION_ID="f401adca-63c1-44e1-9aa3-9c9d18d3fc1b"
export TF_VAR_storage_account_name="tfbackendepamarmpit"
export TF_VAR_container_name="terraformstate"
export TF_VAR_key="armpit-dbw-01.tfstate"
export TF_VAR_resource_group_name="rg-iac-backend"

echo -e "${GREEN}########## [Armando Pit.] Visual Studio Professional Subscription(environment: $environment) DEPLOYMENT ##########${NC}"
subscriptionName=$(az account show --query name -o tsv)
subscriptionId=$(az account show --query id -o tsv)
echo -e "\n${PURPLE}---- Your account is logged into the current subscription: $subscriptionName ----${NC}"
if [ "$subscriptionId" != "$ARM_SUBSCRIPTION_ID" ]; then
    echo -e "\n${RED}---- You are not logged into the correct subscription, please login into the correct subscription and try again ----${NC}"
    exit 0
fi
echo -e ""
echo -e "\n\r******* To start the terraform plan process, press enter ... *******"
read varinput
if [ "$deleteTerraformFolder" == "true" ]; then
    echo -e "${RED}----- Deleting '.terraform' folder ... -----${NC}"
    rm -rf .terraform
fi

echo -e "----- Remove existing $environment.plan/.plan.json file -----"
rm -f localdeploy/$environment.plan
rm -f localdeploy/$environment.plan.json
echo "-------- Terraform Format ---------"
terraform fmt -recursive

echo "-------- Terraform Init in progress ... ---------"
terraform init \
-backend-config="storage_account_name=$TF_VAR_storage_account_name" \
-backend-config="container_name=$TF_VAR_container_name" \
-backend-config="key=$TF_VAR_key" \
-backend-config="resource_group_name=$TF_VAR_resource_group_name"

echo "-------- Terraform Validate ---------"
terraform validate
echo -e "-------- If the validation is OK press enter to continue ..."
read varinput
echo "-------- Terraform Plan in progress ... ---------"
terraform plan -out="localdeploy/$environment.plan"
echo "-------- Terraform Apply ---------"
echo -e "\n\r${BLUE}TERRAFORM APPLY press [Y] to confirm ...${NC}"
read varinput
if [ "$varinput" != "Y" ]; then
    echo "You have not confirmed the deployment, exiting..."
    exit 0
fi
echo "In progress ..."
terraform apply localdeploy/$environment.plan 