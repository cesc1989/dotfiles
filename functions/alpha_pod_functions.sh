#!/bin/bash

## Auto-login to latest pod for each service in Alpha env.

# Also aliased as pae
function alpha_edge_pod() {
  latest_pod=$(kubectl get po -n backend --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n backend "$latest_pod" -- sh
}

# Also aliased as pam
function alpha_marketplace_pod() {
  latest_pod=$(kubectl get po -n marketplace --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n marketplace "$latest_pod" -- sh
}

# Also aliased as pag
function alpha_grimoire_pod() {
  latest_pod=$(kubectl get po -n grimoire --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n grimoire "$latest_pod" -- sh
}

## Las anteriores son veriones mejores que esta.
#
## Log into service Pod
#
# Example:
#
#     alpha_service_pod forms [POD_ID]
function alpha_service_pod() {
  service_name=$1
  service_id=$2
  valid_services="edge, marketplace"

  case $service_name in
    edge)
      kubectl exec -it -n backend "backend-$service_id" -- sh
      ;;
    marketplace)
      kubectl exec -it -n marketplace "marketplace-$service_id" -- sh
      ;;
    *)
      echo -e "Valid services are:\n $valid_services"
      ;;
  esac
}
