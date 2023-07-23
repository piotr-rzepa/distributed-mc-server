# Distributed-mc-server

The aim of this project is to provide a distributed [Minecraft](https://www.minecraft.net/en-us) server in Kubernetes, providing high availability, scalability and fault tolerance.\

## Running single Minecraft server across multiple instances

[MultiPaper](https://github.com/MultiPaper/MultiPaper) is a tool, that provides primary-replica architecture for running Minecraft servers, coordinating server data with each replica.

## Kubernetes Cluster setup

The server infrastructure is running on local Kubernetes cluster on Docker container nodes, created by [Kind](https://kind.sigs.k8s.io/).

The configuration for simple non-HA cluster with 1 control-plane node and two workers nodes is available in `kind-config.yaml`.\
You can create a cluster by running

```bash
kind create cluster --name minecraft --config kind-config.yaml --image kindest/node:v1.27.3
```
