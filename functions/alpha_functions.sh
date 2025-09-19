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

## Read/Copy to Alpha S3 buckets
#
#  Ejemplo:
#
#    alpha_s3_ls luna-alpha-workloads-data-lake/
#
#    alpha_s3_ls luna-alpha-workloads-data-lake/business-operations/
#
#    alpha_s3_ls luna-alpha-workloads-data-lake/business-operations/therapist-forward-fill/
#
function alpha_s3_ls() {
  setaws alpha

  aws s3 ls $1
}

## Copiar archivo de local a bucket en S3 o viceversa.
#
#  Ejemplo:
#
#    alpha_s3_cp ~/Downloads/archivo.txt s3://luna-alpha-workloads-data-lake/business-operations/
#
#    alpha_s3_cp s3://luna-alpha-workloads-data-lake/business-operations/archivo.txt ~/Downloads/archivo.txt
#
function alpha_s3_cp() {
  setaws alpha

  aws s3 cp $1 $2
}
