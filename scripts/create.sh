#!/usr/bin/env bash

kube () {
  kubectl apply -f $1
}

create-cluster () {
  echo "Creating a $NUM_NODES node cluster of $MACHINE VMs with $DISK GB size disks."
  gcloud container clusters create --disk-size $DISK --machine-type $MACHINE --num-nodes $NUM_NODES $CLUSTER 
  gcloud container clusters get-credentials $CLUSTER
}

create-disks () {
  echo "Creating persistent disks for the tick stack..."
  echo "InfluxDB Disk: $INFLUX_DISK"
  echo "Kapacitor Disk: $OTHER_DISK"
  echo "chronograf Disk: $OTHER_DISK"
  gcloud compute disks create chronograf kapacitor --size=$OTHER_DISK
  gcloud compute disks create influxdb --size=$INFLUX_DISK
}

create-tick () {
  echo "Creating tick..."
  echo "tick is the full stack of InfluxData products running in production configuration"
  kube $BP/namespace.yaml
  kubectl create configmap --namespace tick telegraf-config --from-file $BP/telegraf/telegraf.conf
  kubectl create configmap --namespace tick influxdb-config --from-file $BP/influxdb/influxdb.conf
  kube $BP/influxdb/deployment.yaml
  kube $BP/influxdb/service.yaml
  kube $BP/kapacitor/deployment.yaml
  kube $BP/kapacitor/service.yaml
  kube $BP/telegraf/daemonset.yaml
  kube $BP/chronograf/deployment.yaml
  kube $BP/chronograf/service.yaml
  echo "Waiting for public IP..."
  kubectl get svc --namespace tick chronograf -w
}

create-usage () {
  cat <<-HERE 
  $0 create
  - create has the following subcommands
  
    - creates cluster to run this example
    $ $0 create cluster
    
    - creates all gcloud persistent disks for this application 
    $ $0 create disks
  
    - creates all kube based resources for this application 
    $ $0 create tick
    
HERE
}

create () {
  case $1 in
    tick)
      create-tick
      exit 0
      ;;
    cluster)
      create-cluster
      exit 0
      ;;
    disks)
      create-disks
      exit 0
      ;;
    *)
      echo "USAGE: $0 $1"
      create-usage
      exit 1
      ;;
  esac
}

