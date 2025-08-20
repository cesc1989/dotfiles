#!/bin/bash

## Auto-login to latest pod for each service in Alpha env.

# Also aliased as pat
function alpha_therapists_pod() {
  latest_pod=$(kubectl get po -n therapist-credentialing-backend --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n therapist-credentialing-backend "$latest_pod" -- sh
}

# Also aliased as pae
function alpha_edge_pod() {
  latest_pod=$(kubectl get po -n backend --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n backend "$latest_pod" -- sh
}

function alpha_marketplace_pod() {
  latest_pod=$(kubectl get po -n marketplace --sort-by=.metadata.creationTimestamp | tail -1 | awk '{print $1}')
  kubectl exec -it -n marketplace "$latest_pod" -- sh
}
