#!/bin/bash

# Helper function
kube () {
  kubectl apply -f $1
}

# Create the namespace for the TICK stack to live in
kube namespace.yml

# Create the configmaps for each of the services
kubectl create configmap --namespace tick telegraf-config --from-file telegraf/telegraf.conf
kubectl create configmap --namespace tick influxdb-config --from-file influxdb/influxdb.conf
kubectl create configmap --namespace tick kapacitor-config --from-file kapacitor/kapacitor.conf

# Create and expose the InfluxDB service
kube influxdb/deployment.yml
kube influxdb/service.yml

# Create and expose the Kapacitor service
kube kapacitor/deployment.yml
kube kapacitor/service.yml

# Create the telegraf daemonset
kube telegraf/daemonset.yml

# Create and expose the Chronograf service
kube chronograf/deployment.yml
kube chronograf/service.yml
kube chronograf/ingress-http.yml

