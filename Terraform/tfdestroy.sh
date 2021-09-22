#!/bin/bash
terraform init
terraform destroy --auto-approve  --var-file=siteA.tfvars -parallelism=1
