[TOC]

## Introduction

This Repo will act as a base for setting up Networking Labs.

> This script and all commands have been tested in Azure CloudShell. Please prefer it over other shells for this LAB.

## Getting Started

To use the scripts in your environment, clone the repository:

```bash
$ git clone https://github.com/ACT-Automation-Labs/network-labs.git
```

..give executable access to the scripts and start them. For example:

```bash
$ cd network-labs/
$ chmod +x setup-lab-1.sh
$ sh setup-lab-1.sh
```

Once the Script completes, the following resources are created:

- 2 VNets
- 2 AKS Clusters
- 2 Subnets and 2 NSGs
- 2 Virtual Machines using the above Subnets and NSGs

Verify the resources and find out the relation between them.

Maybe use VNet Topology: https://docs.microsoft.com/en-us/azure/network-watcher/view-network-topology



Connect to both the clusters one after other, using 'az aks get-credentials', and apply the Deployment and Service Files:

```bash
## Create Deployment
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/deployment.yaml

## Create Service
$ kubectl apply -f https://raw.githubusercontent.com/ACT-Automation-Labs/network-labs/main/k8s-yaml/service.yaml
```

Verify that the resources are created

```bash
$ kubectl get deploy,svc
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/udp-server   4/4     4            4           52s

NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)           AGE
service/kubernetes   ClusterIP      10.0.0.1      <none>        443/TCP           23m
service/udp-server   LoadBalancer   10.0.144.10   192.161.0.6     20001:30535/UDP   27s
```



From the VM, access the Service

```bash
$ git clone https://github.com/rishasi/udp-client-server.git
$ cd udp-client-server/client
$ python3 client.py <LB_IP>
```



## Challenges

1. Why is the Service not reachable on the Internal IP?

   Source Code for the Server is here: https://github.com/rishasi/udp-client-server/blob/main/server/server.py

2. Once the issue is resolved, initiate the traffic from VM to AKS Service, and take a packet capture on the VM and the AKS Node.
   - If there are more than 1 AKS Nodes, on which node do we take the PCAP? What are the options we have?
   
3. Once the Packet Capture is taken, analyze the PCAP file and draw a Request-Response Flow including as many components as possible.



### Some Links to help:

- Taking PCAPs for AKS: https://docs.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/capture-tcp-dump-linux-node-aks