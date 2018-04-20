# Microsoft Azure Login
az login

# Create Distribution user
az webapp deployment user set \
    --user-name sandboxusr01 \
    --password SNBdxs201

# Create Resource Group
az group create \
    --name SandboxGroup02 \
    --location "North Europe"

# Create AppPlan into Resource Group
az appservice plan create \
    --name SandboxPlan \
    --resource-group SandboxGroup02 \
    --sku S1 \
    --is-linux

# List runtime to use on linux
az webapp list-runtimes
az webapp list-runtimes --linux
az appservice list-locations \
    --sku S1 \
    --linux-workers-enabled

az sql server create \
    --name DB-BOX \
    --resource-group SandboxGroup02 \
    --location "North Europe" \
    --admin-user sandbox \
    --admin-password SNBdxs210

az sql server firewall-rule create \
    --resource-group SandboxGroup02 \
    --server db-sbox \
    --name AllowAccessFromAzure \
    --start-ip-address 0.0.0.0 \
    --end-ip-address 0.0.0.0

az sql db create \
    --resource-group SandboxGroup02 \
    --server db-sbox \
    --name coreDB \
    --service-objective S0

Server=tcp:db-sbox.database.windows.net,1433;Initial Catalog=coreDB;Persist Security Info=False;User ID=sandbox;Password=SNBdxs210;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;

# Create Distribution user
az webapp deployment user set \
    --user-name sandboxusr01 \
    --password SNBdxs201

# Create webapp
az webapp create \
    --resource-group SandboxGroup02 \
    --plan SandboxPlan \
    --name Webtest01 \
    --runtime "dotnetcore|1.1" \
    --deployment-local-git \
    | jq --raw-output '.deploymentLocalGitUrl, .defaultHostName'

# Add Environment variables
az webapp config connection-string set \
    --resource-group SandboxGroup02 \
    --name Webtest01 \
    --settings MyDbConnection='Server=tcp:db-sbox.database.windows.net,1433;Initial Catalog=coreDB;Persist Security Info=False;User ID=sandbox;Password=SNBdxs210;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;' \
    --connection-string-type SQLServer

az webapp config appsettings set \
    --name Webtest01 \
    --resource-group SandboxGroup02 \
    --settings ASPNETCORE_ENVIRONMENT="Production"


# Test creation webapp
open -a "Google Chrome" http://webtest01.azurewebsites.net

# Create Webapp Repo
git submodule add \
    git@github.com:giulianolatini/dotnetWebapp.git \
    dotnetWebapp

git submodule add \
    https://github.com/azure-samples/dotnetcore-sqldb-tutorial \
    dotnetcore-sqldb-tutorial

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

# Cleaner
az group delete --name SandboxGroup02

Get-AzureRmResourceGroup -Name "SandboxGroup02" | Remove-AzureRmResourceGroup -Verbose -Force
