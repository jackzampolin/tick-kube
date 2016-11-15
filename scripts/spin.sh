#!/usr/bin/env bash

spin () {
  case $1 in 
    up)
      config set
      create cluster
      create disks
      create tick
      exit 0
      ;;
    down)
      delete cluster
      delete disks
      exit 0
      ;;
    *)
      echo "USAGE: $0 $1"
      spin-usage
      exit 1
      ;;
  esac
}

spin-usage () {
  cat <<-HERE
  $0 spin
  - spin has the following subcommands
  
    - spins up a new cluster w/ all resources and provisions the full tick stack
    $ $0 spin up

    - deletes the cluster and all associated resources
    $ $0 spin down
    
HERE
}
