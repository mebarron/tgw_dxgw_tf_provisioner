#1/bin/bash 

export TF_VAR_AWS_ACCOUNT_A_NUMBER=
export TF_VAR_AWS_ACCOUNT_B_NUMBER=
export TF_VAR_AWS_DX_ACCOUNT_NUMBER=

python3 tfexecutor.py account_a account_b account_a_attachment account_b_attachment direct_connect apply
