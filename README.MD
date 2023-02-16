# Terraform automation to deploy multi-account, multi-region VPC, Transit Gateway, and Direct Connect Gateway mesh architecture 

## How it works 

- Configure AWS accounts as environment variables
- Create an IAM role to assume and trust policy in each account 
- tfrunner.py script to loop through each main.tf and provision resources
- Use Terraform outputs and provider aliases to switch between accounts

