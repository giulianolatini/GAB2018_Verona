az group create --name SandboxGroup --location "West Europe"
# Deploy storage account
az group deployment create --resource-group SandboxGroup --template-file ../Templates/AzureDeploy.json
# Deploy VM
az group deployment create \
    --name RHEL-VOID-1 \
    --resource-group SandboxGroup \
    --template-file Templates/RHEL/azuredeploy.json \
    --parameters @Templates/RHEL/azuredeploy.parameters.json

# Validation Tests
az group deployment show \
    --name RHEL-VOID-1 \
    --resource-group SandboxGroup 
ssh-copy-id rheladmin@rhel-void-1.westeurope.cloudapp.azure.com
ssh rheladmin@rhel-void-1.westeurope.cloudapp.azure.com
# Check which packages maybe updates
ssh rheladmin@rhel-void-1.westeurope.cloudapp.azure.com -t "sudo yum check-update"

ansible all -i Ansible/inventories/staging/hosts -m ping


# Cleaner
az group delete --name SandboxGroup

