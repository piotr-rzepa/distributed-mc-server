# Distributed-mc-server

The aim of this project is to provide a distributed [Minecraft](https://www.minecraft.net/en-us) server in Kubernetes, providing high availability, scalability and fault tolerance.

## Running single Minecraft server across multiple instances

[MultiPaper](https://github.com/MultiPaper/MultiPaper) is a tool, that provides primary-replica architecture for running Minecraft servers, coordinating server data with each replica.

## Kubernetes Cluster setup

The server infrastructure is running on local Kubernetes cluster on Docker container nodes, created by [Kind](https://kind.sigs.k8s.io/).

The configuration for simple non-HA cluster with 1 control-plane node and two workers nodes is available in `kind-config.yaml`.\
You can create a cluster by running

```bash
kind create cluster --name minecraft --config kind-config.yaml --image kindest/node:v1.27.3
```

## Building Docker Images for primary/replica servers

You can use `build.sh` script in root directory to create Docker images for both primary and replica MultiPaper server instances, for example:

```bash
chmod +x ./build.sh
./build.sh \
    -f docker/Dockerfile-primary \
    -t mpaper-primary:latest \
    -b <MULTIPAPER BUILD VERSION> \
    -m <MULTIPAPER MINECRAFT VERSION>
```

> You can see available minecraft versions as well as multipaper build version in the [download](https://multipaper.io/download.html) section at multipaper.io.

To load the images into local Kind cluster, run:

```bash
kind load docker-image <IMAGE_TAG> -n <YOUR_KIND_CLUSTER_NAME>
```

> If you're using `latest` tag, remember to set `imagePullPolicy` to `Never` or `IfNotPresent` in your Pod manifest, otherwise Kubernetes always tries to pull the image from Docker Hub repository.
