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
RESOURCE_GROUP=tech-prof-lab-2-${APPEND}
echo "\n--> Creating resource group ${RESOURCE_GROUP}..."

az group create --name $RESOURCE_GROUP --location $LOCATION -o table 1>/dev/null

sleep 10

## Create a VNet for resources
echo "\n--> Creating VNet and Subnet"

az network vnet create -g $RESOURCE_GROUP --location $LOCATION \
-n custom-vnet-${APPEND} --address-prefix 192.161.0.0/16 \
--subnet-name custom-subnet-${APPEND} --subnet-prefix 192.161.0.0/24 1>/dev/null

## Store the Values

VNET_ID=$(az network vnet show -g $RESOURCE_GROUP --name custom-vnet-${APPEND} --query id -o tsv)
SUBNET_ID=$(az network vnet subnet show -g $RESOURCE_GROUP --vnet-name custom-vnet-${APPEND} --name custom-subnet-${APPEND} --query id -o tsv)


## Create AKS Cluster
echo "\n--> Creating AKS Clusters"

az aks create \
    --resource-group $RESOURCE_GROUP \
    --name aks-cluster-${APPEND} \
    --node-count 2 \
    --network-plugin azure \
    --service-cidr 10.1.0.0/16 \
    --dns-service-ip 10.1.0.10 \
    --docker-bridge-address 172.18.0.1/16 \
    --vnet-subnet-id $SUBNET_ID \
    --generate-ssh-keys \
    --yes 1>/dev/null

## Create the Client VM
echo "\n--> Creating Client VM"

az vm create -n client-vm -g $RESOURCE_GROUP \
    --image UbuntuLTS \
    --admin-username azureuser \
    --admin-password Passw0rd@123 \
    --subnet $SUBNET_ID \
    --public-ip-sku Standard

sleep 10

## Get the AKS Credentials
az aks get-credentials -n aks-cluster-${APPEND} -g $RESOURCE_GROUP --overwrite-existing

## Create the Deployment and Service
kubectl create -f https://raw.githubusercontent.com/rishasi/udp-client-server/main/k8s-yaml/server-deployment.yaml 1>/dev/null
kubectl create -f https://raw.githubusercontent.com/rishasi/udp-client-server/main/k8s-yaml/server-ilb-service.yaml 1>/dev/null