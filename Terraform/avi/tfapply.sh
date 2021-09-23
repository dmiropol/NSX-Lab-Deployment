#!/bin/bash
# terraform init
# terraform apply --auto-approve  --var-file=cloud_nsxt.tfvars
terraform apply --auto-approve  --var-file=cloud_vcenter.tfvars
