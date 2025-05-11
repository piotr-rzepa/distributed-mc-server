# Distributed Minecraft Server #

The aim of this project is to provide a distributed [Minecraft](https://www.minecraft.net/en-us) server in a containerized environment, providing high availability, scalability and fault tolerance.

It starts as a simple deployment using [Docker compose](https://docs.docker.com/compose/) and then moving into the [Kubernetes](https://kubernetes.io/), first using plain YAML manifests to then evolve to the package deployable using [Helm](https://helm.sh/).

## Running single Minecraft server across multiple instances ##

[MultiPaper](https://github.com/MultiPaper/MultiPaper) is a solution, that provides control-plane/worker architecture for running Minecraft servers, coordinating server data with each worker.

Thanks to distributing load across multiple servers, it's a suitable choice for hosting servers with a player base up to thousands, because of it distributed nature and ability to scale horizontally.

## Quick Start ##

### Docker ###

Go to the `1-docker-compose directory/` and run:

```bash
docker compose up --remove-orphans --build --force-recreate
```

It'll automatically build _master_ and _server_ images from Dockerfiles located in `docker/` directory, mount the config files and run the services.

You can connect to the server from `localhost` at port `8080`.

All configuration files are located in `1-docker-compose/config/` directory and can be adjusted if needed.

### Kubernetes ###

#### Plain YAML manifests ####

> If you don't have a Kubernetes cluster created, see [Creating Kubernetes cluster using Kind](#creating-kubernetes-cluster-using-kind) section before proceeding

Go to the `2-k8s-yamls/` directory and run:

```bash
kubectl apply -f .
```

> If you're running this setup in the Kind, you need to load the server and worker images into the cluster (or pushing them to a registry available over the internet).\
For more information on how to load the locally built images into the Kind cluster, see [Building docker images](#building-docker-images) section.

It will create a namespace called `minecraft` and deploy _master_ as a StatefulSet and _server_ as a Deployment with a single replica. The configuration files for server are mounted to the pod from a ConfigMap.

Both workloads are exposed using a Service resource, which type could be adjusted to e.g. expose the server on the host using _NodePort_.

#### Helm ####

TBA

## Creating Kubernetes cluster using Kind

The MultiPapers' master and worker(s) infrastructure can be run on a local Kubernetes cluster, created by [Kind](https://kind.sigs.k8s.io/), which runs the Kubernetes nodes as docker containers.

The configuration for simple cluster with 1 control-plane node and two workers nodes is available in `kind-config.yaml`.

To create a Kind cluster, run:

```bash
kind create cluster --config kind-config.yaml
```

It will automatically provision a Kind cluster named "mc". You can adjust the name using the different value for `name:` key in the `kind-config.yaml`.

The Kind config maps worker's NodePort _30950_ port to a _8080_ and _8081_ ports on host, meaning you are able to access the servers on your host using `localhost:8080` or `localhost:8081` (depending on which worker node a MultiPaper server was scheduled).

## Building Docker images

The containerized master and worker applications are running in a containers built using custom Docker images, based on `amazoncorretto:24-alpine3.21-jdk` base image.

To see Dockerfiles for both master and server, view the content of the `docker/` directory.

For convenient building of the images (and optionally, loading them into Kind cluster) a Makefile script was written, located in the `docker/` directory.

You can use `make` utility to run the script defined by `Makefile` to create Docker images for both master and server instances as follows:

```bash
make build/all DOCKER_BUILD_ARGS="MULTIPAPER_MC_VERSION=1.20.1 MULTIPAPER_BUILD_NUMBER=57 MULTIPAPER_MASTER_VERSION=2.12.3"
```

It'll build images for both server and worker (with `:latest` tag) for given Minecraft version, MultiPaper build number and MultiPaper master version.

> You can see Minecraft versions supported by MultiPaper as well as the MultiPaper's build versions at the [download](https://multipaper.io/download.html) section at multipaper.io.

If you want to use a specific tag in your deployment, you can tell make to also generate an additional tag, which will be a short unique version of SHA1 hash of the revision you're running the `make` command on, by setting a `BUILD_ID_TAG` to a non-empty value:

```bash
make build/all DOCKER_BUILD_ARGS="MULTIPAPER_MC_VERSION=1.20.1 MULTIPAPER_BUILD_NUMBER=57 MULTIPAPER_MASTER_VERSION=2.12.3" BUILD_ID_TAG="true"
```

> If you're using images "loaded" into the cluster, remember to set `imagePullPolicy` to `Never` or `IfNotPresent` in your Pod manifest, otherwise Kubernetes will always try to pull the image from Docker Hub repository.

To load the images into the local Kind cluster, run:

```bash
make load/kind/all DOCKER_BUILD_ARGS="MULTIPAPER_MC_VERSION=1.20.1 MULTIPAPER_BUILD_NUMBER=57 MULTIPAPER_MASTER_VERSION=2.12.3"
```

Similarly, if you want to load not only the `latest` tag into the Kind cluster, set the `BUILD_ID_TAG` to a non-empty value.

you can combine both of the steps and build + load the images in a single command, by running:

```bash
make all DOCKER_BUILD_ARGS="MULTIPAPER_MC_VERSION=1.20.1 MULTIPAPER_BUILD_NUMBER=57 MULTIPAPER_MASTER_VERSION=2.12.3"
```
