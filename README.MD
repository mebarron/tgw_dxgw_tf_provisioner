# Transit Gateway, Direct Connect, VPC Mesh Network Architecture

- Clean project layout for multi-account multi-region
- Connect thousands of VPCs to Transit Gateway

## How it works 

- Configure AWS accounts as environment variables
- Create IAM role to assume and trust policy in each account 
- tfrunner.py script to loop through each main.tf and provision resources
- Use Terraform outputs and provider aliases to switch between accounts

