#!/bin/bash
terraform init
terraform destroy --auto-approve  --var-file=siteB.tfvars
