# Distributed-mc-server

The aim of this project is to provide a distributed [Minecraft](https://www.minecraft.net/en-us) server in Kubernetes, providing high availability, scalability and fault tolerance.

## Running single Minecraft server across multiple instances

[MultiPaper](https://github.com/MultiPaper/MultiPaper) is a tool, that provides master-worker architecture for running Minecraft servers, coordinating server data with each worker.

## Local kubernetes setup using Kind

The server infrastructure is running on local Kubernetes cluster on Docker container nodes, created by [Kind](https://kind.sigs.k8s.io/).

The configuration for simple non-HA cluster with 1 control-plane node and two workers nodes is available in `kind-config.yaml`.\
You can create a cluster by running

```bash
kind create cluster --name minecraft --config kind-config.yaml --image kindest/node:v1.27.3
```

## Building custom Docker Images for master/worker servers

You can use `build.sh` script in root directory to create Docker images for both master and worker MultiPaper server instances, for example:

```bash
chmod +x ./build.sh
./build.sh \
    -f docker/Dockerfile-master \
    -t mpaper-master:latest \
    -b <MULTIPAPER BUILD VERSION> \
    -m <MULTIPAPER MINECRAFT VERSION>
```

> You can see available minecraft versions as well as multipaper build version in the [download](https://multipaper.io/download.html) section at multipaper.io.

To load the images into local Kind cluster, run:

```bash
kind load docker-image <IMAGE_TAG> -n <YOUR_KIND_CLUSTER_NAME>
```

> If you're using `latest` tag, remember to set `imagePullPolicy` to `Never` or `IfNotPresent` in your Pod manifest, otherwise Kubernetes always tries to pull the image from Docker Hub repository.

## Installing Helm Chart

## Configuration options

The following table lists the configurable parameters of the Multipaper chart and their default values.

| Parameter                | Description             | Default        |
| ------------------------ | ----------------------- | -------------- |
| `master.nameOverride` | Name of the master server and all its related resources. | `""` |
| `master.fullnameOverride` | Fully qualified name of master server and all its related resources. Do not exceeds 63 characters. | `""` |
| `master.image.repository` | Name of the repository to pull the images from | `"multipaper-master"` |
| `master.image.pullPolicy` | Instructs the kubelet how to act should act during the image pull | `"IfNotPresent"` |
| `master.image.tag` | Tag to use for pulled image | `"latest"` |
| `master.replicaCount` | Number of replicas for master server | `1` |
| `master.imagePullSecrets` | Authorization token(s) to use by Docker when pulling image from a private container registry | `[]` |
| `master.resources` | Maximum and requested amount of CPU or Memory (or both) which can be requested, allocated and consumed by a Pod | `{}` |
| `master.nodeSelector` | Options to constrain Pods to nodes with specific labels | `{}` |
| `master.tolerations` | Options applied to pods to allow them to be scheduled with matching taints | `[]` |
| `master.affinity` | Options to constrain Pods to nodes with specific labels, with more control over the selection logic than nodeSelector | `{}` |
| `master.podAnnotations` | Arbitrary non-identifying metadata attached to objects | `{}` |
| `master.podSecurityContext` | Defines privilege and access control settings for a Pod | `{}` |
| `master.securityContext` | Defines privilege and access control settings for a Container | `{}` |
| `master.service.enabled` | Create Service for master server(s) | `true` |
| `master.service.type` | Service type | `"ClusterIP"` |
| `master.service.port` | Service port, which should equal the target port on the Pod | `35353` |
| `worker.nameOverride` |  | `""` |
| `worker.fullnameOverride` |  | `""` |
| `worker.image.repository` | Name of the repository to pull the images from | `"multipaper-worker"` |
| `worker.image.pullPolicy` | Instructs the kubelet how to act should act during the image pull | `"IfNotPresent"` |
| `worker.image.tag` | Tag to use for pulled image | `"latest"` |
| `worker.image.args` | Additional arguments passed to the Pod's command | `["-Xmx1024M", "-Xms1024M", "-jar", "worker.jar", "nogui"]` |
| `worker.replicaCount` | Number of replicas for worker server. Each worker is assigned a unique identifier in multipaper.yaml via init container processing | `2` |
| `worker.imagePullSecrets` | Authorization token(s) to use by Docker when pulling image from a private container registry | `[]` |
| `worker.resources` |  | `{}` |
| `worker.nodeSelector` | Options to constrain Pods to nodes with specific labels | `{}` |
| `worker.tolerations` | Options applied to pods to allow them to be scheduled with matching taints | `[]` |
| `worker.affinity` | Options to constrain Pods to nodes with specific labels, with more control over the selection logic than nodeSelector | `{}` |
| `worker.podAnnotations` | Arbitrary non-identifying metadata attached to objects | `{}` |
| `worker.podSecurityContext` | Defines privilege and access control settings for a Pod | `{}` |
| `worker.securityContext` | Defines privilege and access control settings for a Container | `{}` |
| `worker.service.enabled` | Create Service for worker server(s) | `true` |
| `worker.service.type` | Service type | `"ClusterIP"` |
| `worker.service.port` | Service port, which should equal the target port on the Pod | `25565` |
| `worker.eula` |  | `true` |
| `worker.multipaperProperties.advertise_to_built_in_proxy` |  | `false` |
| `worker.multipaperProperties.files_to_not_sync` |  | `["plugins/bStats"]` |
| `worker.multipaperProperties.files_to_only_upload_on_server_stop` |  | `["plugins/MyPluginDirectory/my_big_database.db"]` |
| `worker.multipaperProperties.files_to_sync_in_real_time` |  | `["plugins/MyPluginDirectory/userdata"]` |
| `worker.multipaperProperties.files_to_sync_on_startup` |  | `["myconfigfile.yml", "plugins/MyPlugin.jar"]` |
| `worker.multipaperProperties.log_file_syncs` |  | `true` |
| `worker.multipaperProperties.sync_entity_ids` |  | `true` |
| `worker.multipaperProperties.sync_json_files` |  | `true` |
| `worker.multipaperProperties.sync_permissions` |  | `false` |
| `worker.multipaperProperties.sync_scoreboards` |  | `true` |
| `worker.serverProperties.level_name` |  | `"helm-world"` |
| `worker.serverProperties.motd` |  | `"A Minecraft Server"` |
| `worker.serverProperties.max_players` |  | `2` |
| `worker.serverProperties.pvp` |  | `true` |
| `worker.serverProperties.enfore_secure_profile` |  | `true` |
| `worker.serverProperties.generate_structure` |  | `true` |
| `worker.serverProperties.use_native_transport` |  | `true` |
| `worker.serverProperties.enable_status` |  | `true` |
| `worker.serverProperties.broadcast_rcon_to_ops` |  | `true` |
| `worker.serverProperties.allow_nether` |  | `true` |
| `worker.serverProperties.sync_chunk_writes` |  | `true` |
| `worker.serverProperties.spawn_npcs` |  | `true` |
| `worker.serverProperties.broadcast_console_to_ops` |  | `true` |
| `worker.serverProperties.spawn_animals` |  | `true` |
| `worker.serverProperties.spawn_monsters` |  | `true` |

---
_Documentation generated by [Frigate](https://frigate.readthedocs.io)._
