# Microsoft Azure Login
az login

# Create Distribution user
az webapp deployment user set \
    --user-name sandboxusr01 \
    --password SNBdxs201

# Create Resource Group
az group create \
    --name SandboxGroup02 \
    --location "West Europe"

# Create AppPlan into Resource Group
az appservice plan create \
    --name SandboxPlan \
    --resource-group SandboxGroup02 \
    --sku S1 \
    --is-linux

# List runtime to use on linux
az webapp list-runtimes
az webapp list-runtimes --linux

# Create webapp
az webapp create \
    --resource-group SandboxGroup02 \
    --plan SandboxPlan \
    --name Webtest01 \
    --runtime "dotnetcore|1.1" \
    --deployment-local-git \
    | jq --raw-output '.deploymentLocalGitUrl, .defaultHostName'

# Test creation webapp
open -a "Google Chrome" http://webtest01.azurewebsites.net

# Create Webapp Repo
git submodule add \
    git@github.com:giulianolatini/dotnetWebapp.git \
    dotnetWebapp

# Connect Webapp Repo to Azure Webapp for deploy
git remote add \
    azure \
    https://sandboxusr01@webtest01.scm.azurewebsites.net/Webtest01.git

# Deploy Webapp
git push azure master

# Deploy storage account
az group deployment create \
    --resource-group SandboxGroup02 \
    --template-file Templates/AzureDeploy.json

# Deploy VM
az group deployment create \
    --resource-group SandboxGroup02 \
    --template-file Templates/RHEL/azuredeploy.json \
    --parameters @Templates/RHEL/azuredeploy.parameters.json \
    | jq --raw-output '.properties.outputs.sshCommand.value'

# Validation Tests


# Cleaner
az group delete --name SandboxGroup02

