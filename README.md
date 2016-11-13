# tick-kube

A tool to deploy the InfluxData TICK stack to Google Container engine.

Included are the full set of kubernetes deployment files for the stack.

### Requirements

- [Google Cloud SDK](https://cloud.google.com/sdk/docs/quickstart-mac-os-x)
  * Follow the instructions in the above article.
- [`kubectl`](https://cloud.google.com/sdk/docs/managing-components) installed
  * Once you have configured `gcloud`, run `gcloud components install kubectl`

### Configuration

Pull this repo:

```bash
# Easiest if you have go installed
$ go get -v github.com/jackzampolin/tick-kube

# One extra configuration change
$ git clone git@github.com:jackzampolin/tick-kube.git
```

Personalize the variables in `/tick-kube`:

```bash
# Defaults to go get download. Modify to be root of repo if using git clone
BP=$GOPATH/src/github.com/jackzampolin/tick-kube

# Name of desired cluster.
# If using an existing cluster set that cluster's name
CLUSTER=influx-test-cluster

# Name of gcloud project to use
PROJECT=influx-perf-testing

# gcloud region
REGION=us-west1

# gcloud zone
ZONE=us-west1-b

# num GB of disk for nodes when creating cluster
DISK=100

# gcloud instance types for nodes when creating cluster
MACHINE=n1-standard-1

# Number of nodes when creating kubernetes cluster
NUM_NODES=3

# InfluxDB Disk Size
INFLUX_DISK=25GB

# Chronograf and Kapacitor Disk Sizes
OTHER_DISK=10GB
```

### To Deploy:

This tool offers a couple of different options:

- Create a new cluster and spin up the full stack
- Create the full stack on an existing kubernetes cluster

##### Create a new cluster

To create a new cluster running the full stack and return the IP where chronograf is running:

```bash
$ ./tick-kube spin-up
```

This command is a shortcut that runs following commands in order:

```bash
# First set configuration for gcloud and kubectl to the settings in ./tick-kube
$ ./tick-kube config-set
# Next create a new kubernetes cluster with those configuration parameters
$ ./tick-kube create-cluster
# Create disks for influxdb, chronograf, and kapacitor
$ ./tick-kube create-disks
# Build the chronograf docker container from source and push it to the Google Container Registry for your project
# This script expects chronograf to be located at $GOPATH/src/github.com/influxdata/chronograf
$ ./tick-kube build-chronograf
# Create tick runs `kubectl apply -f $filename` on all manifests and creates associated configmaps
$ ./tick-kube create-tick
```

This command takes a few minutes. It will hang at the end waiting for a public IP for the `chronograf` service:

```bash
Creating tick...
tick is the full stack of InfluxData products running in production configuration
namespace "tick" created
configmap "telegraf-config" created
configmap "influxdb-config" created
deployment "influxdb" created
service "influxdb" created
deployment "kapacitor" created
service "kapacitor" created
daemonset "telegraf" created
deployment "chronograf" created
service "chronograf" created
Waiting for public IP...
NAME         CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
chronograf   10.7.249.214   <pending>     80/TCP    1s
```

Once the `EXTERNAL-IP` is visible visit it in your web browser. The URLs for configuring Influx and Kapacitor from Chronograf are as follows:

```
InfluxDB: http://influxdb.tick:8086
Kapacitor: http://kapacitor.tick:8086
```

##### Create the stack on an existing cluster

Creating the stack on an existing cluster is easy as well. After setting the variables at the top of `/tick-kube` Run the following commands:

```bash
# First set configuration for gcloud and kubectl to the settings in ./tick-kube
$ ./tick-kube config-set
# Create disks for influxdb, chronograf, and kapacitor
$ ./tick-kube create-disks
# Build the chronograf docker container from source and push it to the Google Container Registry for your project
# This script expects chronograf to be located at $GOPATH/src/github.com/influxdata/chronograf
$ ./tick-kube build-chronograf
# Create tick runs `kubectl apply -f $filename` on all manifests and creates associated configmaps
$ ./tick-kube create-tick
```

This command takes a few minutes. It will hang at the end waiting for a public IP for the `chronograf` service:

```bash
Creating tick...
tick is the full stack of InfluxData products running in production configuration
namespace "tick" created
configmap "telegraf-config" created
configmap "influxdb-config" created
deployment "influxdb" created
service "influxdb" created
deployment "kapacitor" created
service "kapacitor" created
daemonset "telegraf" created
deployment "chronograf" created
service "chronograf" created
Waiting for public IP...
NAME         CLUSTER-IP     EXTERNAL-IP   PORT(S)   AGE
chronograf   10.7.249.214   <pending>     80/TCP    1s
```

Once the `EXTERNAL-IP` is visible visit it in your web browser. The URLs for configuring Influx and Kapacitor from Chronograf are as follows:

```
InfluxDB: http://influxdb.tick:8086
Kapacitor: http://kapacitor.tick:8086
```

### Tearing Down

You can tear down either the full cluster or just the Kubernetes objects and persistent disks.

##### Full cluster teardown

To destroy all resources created by this demo run:

```bash
$ ./tick-kube spin-down
```

This command takes a few minutes and will require user input at 2 different places. This command is a shortcut that runs following commands in order:

```bash
# This deletes the tick namespace and removes tick from kubernetes
$ ./tick-kube delete-tick
# This deletes the cluster on google compute cloud and associated LBs
$ ./tick-kube delete-cluster
# This deletes the persistent disks created for InfluxDB, Kapacitor and Chronograf
$ ./tick-kube delete-disk
```

##### Namespace only teardown

To destroy the namespace and the associated persistent disks run the following:

```bash
# This deletes the tick namespace and removes tick from kubernetes
$ ./tick-kube delete-tick
# This deletes the persistent disks created for InfluxDB, Kapacitor and Chronograf
$ ./tick-kube delete-disk
```

> NOTE: `./tick-kube delete-disk` may initially fail. This is because the disks are still mounted to the hosts. Wait a couple of minutes for them to get removed or go into the Google Cloud Console and delete them manually.

### Troubleshooting

If you are getting authentication errors when trying to connect to the cluster try running:

```bash
$ gcloud auth application-default login
```