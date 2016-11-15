#!/usr/bin/env bash

update () {
  case $1 in
    chronograf)
      kubectl delete pods --namespace tick -l app=chronograf
      exit 0
      ;;
    influxdb)
      kubectl delete pods --namespace tick -l app=influxdb
      exit 0
      ;;
    telegraf)
      kubectl delete configmap --namespace tick telegraf-config
      kubectl create configmap --namespace tick telegraf-config --from-file $BP/telegraf/telegraf.conf 
      kubectl delete pod --namespace tick -l app=telegraf
      exit 0
      ;;
    kapacitor)
      kubectl delete pods --namespace tick -l app=kapacitor
      exit 0
      ;;
    *)
      echo "USAGE:"
      update-usage
      exit 1
  esac
}

update-usage () {
  cat <<-HERE
  $0 update {appliation}
    - deletes the pods for this application allowing the RC to spin up new ones
    $ $0 update {application}
    
    {application}:
      - chronograf - pulls new code, builds images, pushes and restarts podss
      - influxdb
      - telegraf - updates configmap and restarts pods
      - kapacitor
HERE
}

