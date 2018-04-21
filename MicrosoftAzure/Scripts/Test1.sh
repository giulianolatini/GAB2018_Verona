# Microsoft Azure Login
az login

# Enter in the workplace
cd GAB2018_Verona/MicrosoftAzure

# Create Resource Group
az group create --name SandboxGroup01 --location "West Europe"
# Deploy storage account
az group deployment create --resource-group SandboxGroup01 --template-file Templates/AzureDeploy.json
# Deploy VM
az group deployment create \
    --resource-group SandboxGroup01 \
    --template-file Templates/RHEL/azuredeploy.json \
    --parameters @Templates/RHEL/azuredeploy.parameters.json \
    | jq --raw-output '.properties.outputs.sshCommand.value'

# Validation Tests
az group deployment show \
    --name RHEL-VOID-1 \
    --resource-group SandboxGroup 
ssh-copy-id rheladmin@rhel-docker-1.westeurope.cloudapp.azure.com
ssh rheladmin@rhel-docker-1.westeurope.cloudapp.azure.com
# Check which packages maybe updates
ssh rheladmin@rhel-docker-1.westeurope.cloudapp.azure.com -t "sudo yum check-update; sudo yum -y update"

ansible all -i Ansible/inventories/staging/hosts -m ping
ansible-playbook -vvv -i Ansible/inventories/staging/hosts Ansible/site.yml

# Cleaner
az group delete --name SandboxGroup01

