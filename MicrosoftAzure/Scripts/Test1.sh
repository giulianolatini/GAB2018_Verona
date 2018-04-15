az group create --name SandboxGroup --location "West Europe"
az group deployment create --resource-group SandboxGroup --template-file ../Templates/AzureDeploy.json
az group delete --name SandboxGroup