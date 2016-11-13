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

Personalize the variables in `/tick`:

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

This repo is designed to be deployed on Google Container engine. There is some specific scripting for that environment here. You need:
- `gcloud` binary installed and configured for the Google Compute Cloud `project` 
- `kubectl` binary installed and configured for the kubernetes `cluster` you wish to use

You can check this configuration by running `./tick config` from the root of this directory:

```bash
$ tick config
CURRENT CONFIG:
  project -> { project_id }
  zone    -> { gce_zone } 
  region  -> { gce_region } 
  cluster -> { gke_cluster_context }
```

gcloud auth application-default login