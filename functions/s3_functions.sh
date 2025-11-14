#!/bin/bash

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
