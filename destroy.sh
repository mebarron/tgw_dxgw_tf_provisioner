#1/bin/bash 

<<<<<<< HEAD
python3 tfexecutor.py account_a account_b account_a_attachment account_b_attachment dxgw_account destroy
=======
python3 tfrunner.py account_a account_b account_a_attachment account_b_attachment direct_connect destroy
>>>>>>> refs/remotes/origin/main

rm ./account_a/.terraform.lock*
rm ./account_a/terraform*
rm -rf ./account_a/.terraform

rm ./account_b/.terraform.lock*
rm ./account_b/terraform*
rm -rf ./account_b/.terraform

rm ./account_a_attachment/.terraform.lock*
rm ./account_a_attachment/terraform*
rm -rf ./account_a_attachment/.terraform

rm ./account_b_attachment/.terraform.lock*
rm ./account_b_attachment/terraform*
rm -rf ./account_b_attachment/.terraform

rm ./dxgw_account/.terraform.lock*
rm ./dxgw_account/terraform*
rm -rf ./dxgw_account/.terraform
