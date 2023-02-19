# Transit Gateway, Direct Connect, VPC Mesh Network Architecture

- Simple project layout for multi-account and multi-region architecture
- Connect thousands of VPCs to Transit Gateway to create mesh architecture

## How it works 

- buid.sh script configures AWS account IDs as Terraform environment variables
- destroy.sh script destroys all of the resources created in each account
- Create IAM role for Terraform to assume and cross-account trust policy
- tfrunner.py script loops through each account's main.tf and provisions resources
- Use Terraform outputs and provider aliases to switch between accounts

## Things to consider

- Production environments should use a remote state backend, such as an S3 bucket
so that state data is shared across teams and projects
- Terraform should run on a dedicated EC2 instance in a shared resoruces or management
account and assume the IAM role in each spoke account
- Configure VPC NACLs, VPC routes tables, and Transit Gateway route tables
- Ideally, this would be managed in a source repo and triggered by some continuous
integration/deployment tool, such as Jenkins or CodePipeline

## Additional accounts

- This project can scale to additional accounts by replicating what has been done in 
account_a and account_b, up to the limit for Transit Gateway peering attachments


