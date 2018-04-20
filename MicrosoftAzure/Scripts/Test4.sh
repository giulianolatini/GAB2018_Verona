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
az group create --name SandboxGroup04 --location eastus

# Create Cluster
az aks create \
  --resource-group SandboxGroup04 \
  --name SandboxAKSCluster \
  --node-count 3 \
  --generate-ssh-keys

# Install Kebernetes cli
az aks install-cli

# Get credential tu access by cli
az aks get-credentials \
  --resource-group SandboxGroup04 \
  --name SandboxAKSCluster

# List nodes
kubectl get nodes

# Deploy Application
kubectl create -f Kubernetes/azure-vote.yml

# Test Application running
kubectl get service azure-vote-front --watch

# Remove Cluster and clean 
az group delete \
  --name SandboxGroup04 \
  --yes \
  --no-wait
