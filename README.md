[TOC]

## Introduction

This Repo will act as a base for setting up Networking Labs.

> This script and all commands have been tested in Azure CloudShell. Please prefer it over other shells for this LAB.



## Labs

1. [Lab 1: Service cannot be accessed, connection refused](#lab-1)
2. [Lab 2: Service cannot be accessed, intermittent timeout](#lab-2)

## Getting Started



### Lab 1

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

This Lab imitates a `Connection Refused` error. 

Once the Script completes, the following resources are created:

- 2 VNets (One for CNI environment and one for Kubenet environment)
- 2 AKS Clusters
- 1 Deployment and 1 Internal Service in both the clusters
- 2 Subnets and 2 NSGs
- 2 Virtual Machines using the above Subnets and NSGs

Verify the resources and find out the relation between them.

Maybe use VNet Topology: https://docs.microsoft.com/en-us/azure/network-watcher/view-network-topology



Connect to both the clusters one after other, using `az aks get-credentials`, and verify the Deployment and Service Files:

```bash
$ kubectl get deploy,svc
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/udp-server   4/4     4            4           52s

NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)           AGE
service/kubernetes   ClusterIP      10.0.0.1      <none>        443/TCP           23m
service/udp-server   LoadBalancer   10.0.144.10   192.161.0.6     20001:30535/UDP   27s
```



SSH to the Client VM for both the setup (CNI environment and Kubenet environment).

From the VM, access the Service

```bash
$ git clone https://github.com/rishasi/udp-client-server.git
$ cd udp-client-server/client
$ python3 client.py <LB_IP>
```

> Note that for SSH, you will need to open Port 22 for VM's NSG

The access will throw error.

#### Challenges

1. Why is the Service not reachable on the Internal IP?

   Source Code for the Server is here: https://github.com/rishasi/udp-client-server/blob/main/server/server.py

2. Once the issue is resolved, initiate the traffic from VM to AKS Service, and take a packet capture on the VM and the AKS Node.
   - If there are more than 1 AKS Nodes, on which node do we take the PCAP? What are the options we have?
   
3. Once the Packet Capture is taken, analyze the PCAP file and draw a Request-Response Flow including as many components as possible.



#### Some Links to help:

- Taking PCAPs for AKS: https://docs.microsoft.com/en-us/troubleshoot/azure/azure-kubernetes/capture-tcp-dump-linux-node-aks

---

### Lab 2

To use the scripts in your environment, clone the repository:

```bash
$ git clone https://github.com/ACT-Automation-Labs/network-labs.git
```

..give executable access to the scripts and start them. For example:

```bash
$ cd network-labs/
$ chmod +x setup-lab-2.sh
$ sh setup-lab-2.sh
```

This Lab imitates a `Intermittent Connection Timed Out` error. 

Once the Script completes, the following resources are created:

- 1 VNet

- 1 AKS Cluster with 2 nodes using Azure CNI Network Plugin

- 1 Deployment and 1 Internal Service in the Cluster

- 1 Virtual Machine in the same Subnet as AKS Cluster Nodes

  

Connect to both the clusters one after other, using `az aks get-credentials`, and verify the Deployment and Service Files:

```bash
$ kubectl get deploy,svc
NAME                         READY   UP-TO-DATE   AVAILABLE   AGE
deployment.apps/udp-server   4/4     4            4           52s

NAME                 TYPE           CLUSTER-IP    EXTERNAL-IP   PORT(S)           AGE
service/kubernetes   ClusterIP      10.0.0.1      <none>        443/TCP           23m
service/udp-server   LoadBalancer   10.0.144.10   192.161.0.6     20001:30535/UDP   27s
```



SSH to the Client VM, and access the Service

```bash
$ curl <Service_IP:Port>
```

> Note that for SSH, you will need to open Port 22 for VM's NSG

The access will time out on some tries, as the issue is intermittent.

#### Challenges

1. Why does the Service throw intermittent timeouts?

2. Replicate the issue and initiate the traffic from VM to AKS Service, and take a packet capture on the VM and the AKS Node.
   - If there are more than 1 AKS Nodes, on which node do we take the PCAP? What are the options we have?

3. Once the Packet Capture is taken, analyze the PCAP file and draw a Request-Response Flow including as many components as possible.



#### Some Links to help:

- https://github.com/kubernetes/kubernetes/issues/95555 
- https://github.com/Azure/azure-container-networking/issues/707 

