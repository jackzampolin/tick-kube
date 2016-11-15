#!/usr/bin/env bash

config-list () {
  project=$(gcloud config list project --format="value(core.project)" 2> /dev/null)
  zone=$(gcloud config list compute/zone --format="value(compute.zone)" 2> /dev/null)
  region=$(gcloud config list compute/region --format="value(compute.region)" 2> /dev/null)
  cluster=$(kubectl config current-context)
  cat <<-HERE
CURRENT CONFIG:
  project -> $project 
  zone    -> $zone 
  region  -> $region 
  cluster -> $cluster 
HERE
}

config-set () {
  echo "Setting PROJECT to '$PROJECT'"
  nohup gcloud config set project $PROJECT > /dev/null
  echo "Setting ZONE to '$ZONE'"
  nohup gcloud config set compute/zone $ZONE > /dev/null
  echo "Setting REGION to '$REGION'"
  nohup gcloud config set compute/region $REGION > /dev/null
  echo "Setting CLUSTER to '$CLUSTER'"
  nohup gcloud container clusters get-credentials $CLUSTER > /dev/null
}

config-usage () {
  cat <<-HERE
  $0 config
  - config has the following subcommands
    
    - lists current gcloud and kubectl context
    $ $0 config list
    
    - sets config to variables at top of file
    $ $0 config set
    
HERE
}

config () {
  case $1 in 
    list)
      config-list
      exit 0
      ;;
    set)
      config-set
      exit 0
      ;;
    *) 
      echo "USAGE: $0 $1"
      config-usage
      exit 1
      ;;
  esac
}

