#!/usr/bin/env bash
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: terraform_destroy.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-02-07>
## Updated: Time-stamp: <2018-02-08 16:01:15>
##-------------------------------------------------------------------
set -e
if [ -z "$do_token" ]; then
    echo -e "Error: do_token parameter should be given."
    exit 1
fi

export working_dir="."

terraform_task_id=${1?}
cd "$working_dir/$terraform_task_id"
# TODO: when deleting, we'd better to ask people to provide both hostname and IP as cross reference
terraform show
terraform destroy -force --var="do_token=$do_token"
## File: terraform_destroy.sh ends
