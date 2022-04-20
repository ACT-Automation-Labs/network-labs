#!/bin/bash

## Global Variables for defaults
LOCATION="eastus"
APPEND=$(openssl rand -hex 4)

## Az Login check
if $(az account list 2>&1 | grep -q 'az login')
then
    echo -e "\n--> Warning: You have to login first with the 'az login' command before you can run this lab tool"
    az login -o table
fi

## Create Resource Group

RESOURCE_GROUP=tech-prof-lab-1-${APPEND}

echo "\n--> Creating resource group ${RESOURCE_GROUP}..."
az group create --name $RESOURCE_GROUP --location $LOCATION -o table 1>/dev/null

sleep 10

# Create 2 VNets: each for CNI and Kubenet

echo "\n--> Creating VNets for 2 AKS Clusters..."
az network vnet create -g $RESOURCE_GROUP --location $LOCATION \
-n kubenet-custom-vnet-${APPEND} --address-prefix 192.161.0.0/16 \
--subnet-name kubenet-custom-subnet-${APPEND} --subnet-prefix 192.161.0.0/24 1>/dev/null

sleep 10

az network vnet create -g $RESOURCE_GROUP --location $LOCATION \
-n cni-custom-vnet-${APPEND} --address-prefix 192.162.0.0/16 \
--subnet-name cni-custom-subnet-${APPEND} --subnet-prefix 192.162.0.0/24 1>/dev/null

sleep 10

## Store the Values

KUBENET_VNET_ID=$(az network vnet show -g $RESOURCE_GROUP --name kubenet-custom-vnet-${APPEND} --query id -o tsv)
KUBENET_SUBNET_ID=$(az network vnet subnet show -g $RESOURCE_GROUP --vnet-name kubenet-custom-vnet-${APPEND} --name kubenet-custom-subnet-${APPEND} --query id -o tsv)

CNI_VNET_ID=$(az network vnet show -g $RESOURCE_GROUP --name cni-custom-vnet-${APPEND} --query id -o tsv)
CNI_SUBNET_ID=$(az network vnet subnet show -g $RESOURCE_GROUP --vnet-name cni-custom-vnet-${APPEND} --name cni-custom-subnet-${APPEND} --query id -o tsv)

## Create KUBENET Cluster

echo "\n--> Creating AKS Clusters"

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name kubenet-cluster-${APPEND} \
    --node-count 2 \
    --enable-managed-identity \
    --network-plugin kubenet \
    --service-cidr 10.0.0.0/16 \
    --dns-service-ip 10.0.0.10 \
    --pod-cidr 10.244.0.0/16 \
    --docker-bridge-address 172.17.0.1/16 \
    --vnet-subnet-id $KUBENET_SUBNET_ID \
    --generate-ssh-keys \
    --yes 1>/dev/null

sleep 10

## Create CNI Cluster
az aks create \
    --resource-group $RESOURCE_GROUP \
    --name cni-cluster-${APPEND} \
    --node-count 2 \
    --network-plugin azure \
    --service-cidr 10.1.0.0/16 \
    --dns-service-ip 10.1.0.10 \
    --docker-bridge-address 172.18.0.1/16 \
    --vnet-subnet-id $CNI_SUBNET_ID \
    --generate-ssh-keys \
    --yes 1>/dev/null

sleep 10

## Get the Kubenet AKS Credentials
az aks get-credentials -n kubenet-cluster-${APPEND} -g $RESOURCE_GROUP --overwrite-existing

## Create Deployment
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/deployment.yaml 1>/dev/null

## Create Service
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/service.yaml 1>/dev/null

sleep 10

## Get the CNI AKS Credentials
az aks get-credentials -n cni-cluster-${APPEND} -g $RESOURCE_GROUP --overwrite-existing

## Create Deployment
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/deployment.yaml 1>/dev/null

## Create Service
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/service.yaml 1>/dev/null



## Create NSG for 2 VMs
echo "\n--> Creating NSG for Custom VMs"

az network nsg create \
    --name kubenet-vm-nsg \
    --resource-group $RESOURCE_GROUP 1>/dev/null 

sleep 5

az network nsg rule create --resource-group $RESOURCE_GROUP \
    --nsg-name kubenet-vm-nsg --name SSHRule \
    --priority 4096 --source-address-prefixes 0.0.0.0/0 \
    --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges 22 80 8080 --access Allow \
    --protocol Tcp --description "Allow access on port 22, 80 and 8080." 1>/dev/null

az network nsg create \
    --name cni-vm-nsg \
    --resource-group $RESOURCE_GROUP 1>/dev/null 

sleep 5

az network nsg rule create --resource-group $RESOURCE_GROUP \
    --nsg-name cni-vm-nsg --name SSHRule \
    --priority 4096 --source-address-prefixes 0.0.0.0/0 \
    --source-port-ranges '*' --destination-address-prefixes '*' \
    --destination-port-ranges 22 80 8080 --access Allow \
    --protocol Tcp --description "Allow access on port 22, 80 and 8080." 1>/dev/null

## Create Subnet for 2 VMs

echo "\n--> Creating new Subnets for Custom VMs"

az network vnet subnet create --name kubenet-vm-subnet \
    --resource-group $RESOURCE_GROUP --vnet-name kubenet-custom-vnet-${APPEND} \
    --address-prefix 192.161.1.0/24 1>/dev/null 

sleep 10

az network vnet subnet create --name cni-vm-subnet \
    --resource-group $RESOURCE_GROUP --vnet-name cni-custom-vnet-${APPEND} \
    --address-prefix 192.162.1.0/24 1>/dev/null 

sleep 10

## Create VM in Kubenet Cluster's VNet, in the new Subnet

echo "\n--> Creating VMs"
az vm create -n kubenet-vm -g $RESOURCE_GROUP \
	--image UbuntuLTS \
	--admin-username azureuser \
	--admin-password Passw0rd@123 \
	--subnet kubenet-vm-subnet \
	--vnet-name kubenet-custom-vnet-${APPEND} \
	--public-ip-sku Standard \
	--nsg kubenet-vm-nsg

## Create VM in CNI Cluster's VNet, in the new Subnet
az vm create -n cni-vm -g $RESOURCE_GROUP \
	--image UbuntuLTS \
	--admin-username azureuser \
	--admin-password Passw0rd@123 \
	--subnet cni-vm-subnet \
	--vnet-name cni-custom-vnet-${APPEND} \
	--public-ip-sku Standard \
	--nsg cni-vm-nsg