az login

# Enter in the workplace
cd GAB2018_Verona/MicrosoftAzure

# Provider Registration
az provider register -n Microsoft.Network
az provider register -n Microsoft.Storage
az provider register -n Microsoft.Compute
az provider register -n Microsoft.ContainerService

# Provider State
az provider show -n Microsoft.Network
az provider show -n Microsoft.Storage
az provider show -n Microsoft.Compute
az provider show -n Microsoft.ContainerService

# Create Resource Group
az group create --name SandboxGroup03 --location westeurope

# Create Swarm
az acs create \
  --name SandboxSwarm \
  --orchestrator-type Swarm \
  --resource-group SandboxGroup03 \
  --agent-count 1 \
  --generate-ssh-keys \
   | jq --raw-output '.properties.outputs.sshMaster0.value'
# List Cluster Pubblic IPs
az network public-ip list \
  --resource-group SandboxGroup03 \
  --query "[*].{Name:name,IPAddress:ipAddress}" \
  -o table

ssh azureuser@sandboxswa-sandboxgroup03-c78595mgmt.westeurope.cloudapp.azure.com -A -p 2200

# Connect to Swarm Cluster
ssh -p 2200 -fNL 2375:localhost:2375 azureuser@sandboxswa-sandboxgroup03-c78595mgmt.westeurope.cloudapp.azure.com
export DOCKER_HOST=:2375



az group delete --name SandboxGroup03 --yes --no-wait