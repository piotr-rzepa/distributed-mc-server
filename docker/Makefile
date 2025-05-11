BUILD_ID := $(shell git rev-parse --short HEAD 2>/dev/null || echo no-commit-id)
WORKSPACE := $(shell pwd)
DOCKER_IMAGE_NAME_MASTER := multipaper/master
DOCKER_MASTER_DOCKERFILE_NAME := master.dockerfile
DOCKER_SERVER_DOCKERFILE_NAME := server.dockerfile
DOCKER_IMAGE_NAME_SERVER := multipaper/server
DOCKER_ARGS ?= --network host --no-cache --progress=plain
DOCKER_BUILD_ARGS :=
BUILD_ID_TAG ?=
KIND_ARGS := $(if $(KIND_CLUSTER_NAME), --name $(KIND_CLUSTER_NAME),)

.PHONY: help
help: ## List targets & descriptions
	@cat Makefile* | grep -E '^[a-zA-Z\/_-]+:.*?## .*$$' | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: id
id: ## Output BUILD_ID being used
	@echo $(BUILD_ID)

.PHONY: mc
mc: ## Output Minecraft/MultiPaper metadata for the build
	@echo $(foreach dcarg,$(DOCKER_BUILD_ARGS),$(dcarg))

.PHONY: debug
debug: ## Output internal make variables used
	@echo BUILD_ID = $(BUILD_ID)
	@echo DOCKER_IMAGE_NAME_MASTER = $(DOCKER_IMAGE_NAME_MASTER)
	@echo DOCKER_MASTER_DOCKERFILE_NAME = $(DOCKER_MASTER_DOCKERFILE_NAME)
	@echo DOCKER_IMAGE_NAME_SERVER = $(DOCKER_IMAGE_NAME_SERVER)
	@echo DOCKER_SERVER_DOCKERFILE_NAME = $(DOCKER_SERVER_DOCKERFILE_NAME)
	@echo WORKSPACE = $(WORKSPACE)

.PHONY: build/master
build/master: mc ## Build a docker image for multipaper master with two tags - build id and latest
	@echo "Building Multipaper master image..."
	docker build $(if $(BUILD_ID_TAG), -t $(DOCKER_IMAGE_NAME_MASTER):$(BUILD_ID),) -t $(DOCKER_IMAGE_NAME_MASTER):latest -f $(DOCKER_MASTER_DOCKERFILE_NAME) $(DOCKER_ARGS) $(foreach dcarg,$(DOCKER_BUILD_ARGS),--build-arg $(dcarg)) $(CURDIR)
	@echo "Multipaper master image built!"

.PHONY: build/server
build/server: mc ## Build a docker image for multipaper server with two tags - build id and latest
	@echo "Building Multipaper server image..."
	docker build $(if $(BUILD_ID_TAG), -t $(DOCKER_IMAGE_NAME_SERVER):$(BUILD_ID),) -t $(DOCKER_IMAGE_NAME_SERVER):latest -f $(DOCKER_SERVER_DOCKERFILE_NAME) $(DOCKER_ARGS) $(foreach dcarg,$(DOCKER_BUILD_ARGS),--build-arg $(dcarg)) $(CURDIR)
	@echo "Multipaper server image built!"

.PHONY: build/all
build/all: build/master build/server ## Build docker image(s) for multipaper master and server

.PHONY: load/kind/master
load/kind/master: ## Load built master image to a local Kind Kubernetes cluster
	kind load docker-image $(if $(BUILD_ID_TAG), $(DOCKER_IMAGE_NAME_MASTER):$(BUILD_ID),) $(DOCKER_IMAGE_NAME_MASTER):latest $(KIND_ARGS)

.PHONY: load/kind/server
load/kind/server: ## Load built server image to a local Kind Kubernetes cluster
	kind load docker-image $(if $(BUILD_ID_TAG), $(DOCKER_IMAGE_NAME_SERVER):$(BUILD_ID),) $(DOCKER_IMAGE_NAME_SERVER):latest $(KIND_ARGS)

.PHONY: load/kind/all
load/kind/all: load/kind/master load/kind/server ## Load built master/server image(s) to a local Kind Kubernetes cluster

.PHONY: all/master
all/master: build/master load/kind/master ## Build docker image for Multipaper master and loads it into Kind cluster

.PHONY: all/server
all/server: build/server load/kind/server ## Build docker image for Multipaper server and loads it into Kind cluster

.PHONY: all
all: build/master load/kind/master build/server load/kind/server ## Build docker image for all Multipaper components and load them into Kind cluster
