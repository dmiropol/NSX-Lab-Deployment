#!/bin/bash
#terraform init
# terraform destroy --auto-approve  --var-file=cloud_nsxt.tfvars
terraform destroy --auto-approve  --var-file=cloud_vcenter.tfvars
