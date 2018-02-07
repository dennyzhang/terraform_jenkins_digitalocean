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
## Updated: Time-stamp: <2018-02-07 17:48:29>
##-------------------------------------------------------------------
set -e

function valid_parameters() {
    # TODO
    # vm_hostname
    # machine_flavor
    # region
    # ssh_keys
    # do_token
}

function terraform_create_vm() {
    vm_hostname=${1?}
    ssh_keys=${2?}
    volume_list=${3?}
    provision_sh=${4:-""}
}

################################################################################
valid_parameters

terraform_task_id=${1?}
terraform_tf_file=${2?}
export vm_image="ubuntu-14-04-x64"
export working_dir="."

mkdir -p "$working_dir/$terraform_task_id"
cd "$working_dir/$terraform_task_id"

terraform_create_vm "$terraform_task_id" "$vm_hostname"

terraform init
terraform apply --var="do_token=$do_token"
# terraform show
## File: terraform_do_create.sh ends
