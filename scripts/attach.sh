#!/usr/bin/env bash

attach-usage () {
  cat <<-HERE
  $0 attach
    - attaches to a pod port for given a namespace and app tag
    $ $0 attach tick influxdb
  
HERE
}

attach () {
  if [ -z $1 ]; then 
    echo "USAGE:"
    attach-usage
    exit 1
  else 
    echo "namespace: '$1'"; 
  fi
  if [ -z $2 ]; 
    then echo "app not specified"; 
    exit 1
  else 
    echo "app: '$2'"; 
  fi
  kubectl port-forward \
    --namespace $1 \
    $(kubectl get pods --namespace $1 -l app=$2 --output=jsonpath="{.items[0].metadata.name}") \
    $(kubectl get pods --namespace $1 -l app=$2 --output=jsonpath="{.items[0].spec.containers[0].ports[0].containerPort}")
}
