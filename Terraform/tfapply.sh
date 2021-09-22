#!/bin/bash
terraform init
terraform apply --auto-approve  --var-file=siteA.tfvars -parallelism=1
