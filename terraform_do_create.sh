#!/usr/bin/env bash
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT 
##   https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: terraform_do_create.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-02-07>
## Updated: Time-stamp: <2018-02-07 17:39:34>
##-------------------------------------------------------------------
set -e

function get_terraform_task_id() {
    localhost vm_hostname=${1?}
    echo "$vm_hostname"
}

function terraform_create_vm() {
    vm_hostname=${1?}
    ssh_keys=${2?}
    volume_list=${3?}
    provision_sh=${4:-""}
}

vm_hostname=${1?}
ssh_keys=${2?}
volume_list=${3?}
provision_sh=${4:-""}
working_dir=${5:-"."}

cd "$working_dir"
terraform_task_id=$(get_terraform_task_id "$vm_hostname")
mkdir -p "$working_dir/$terraform_task_id"
cd "$working_dir/$terraform_task_id"

terraform_create_vm "$terraform_task_id" "$vm_hostname"
# terraform init
# terraform apply --var="do_token=$DO_TOKEN"
# terraform show
## File: terraform_do_create.sh ends
