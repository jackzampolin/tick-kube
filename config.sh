#!/usr/bin/env bash
BP=$GOPATH/src/github.com/jackzampolin/tick-kube

# Name of cluster 
CLUSTER=sales-demo-cluster

# Name of gcloud project
PROJECT=influx-perf-testing

# gcloud region
REGION=us-west1

# gcloud zone
ZONE=us-west1-b

# num GB of disk for nodes 
DISK=100

# gcloud instance types
MACHINE=n1-standard-1

# Number of nodes for kubernetes cluster
NUM_NODES=3

# InfluxDB Disk Size
INFLUX_DISK=25GB

# Chronograf and Kapacitor Disk Sizes
OTHER_DISK=10GB
