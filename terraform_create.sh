#!/usr/bin/env bash
##-------------------------------------------------------------------
## @copyright 2017 DennyZhang.com
## Licensed under MIT
## https://www.dennyzhang.com/wp-content/mit_license.txt
##
## File: terraform_create.sh
## Author : Denny <https://www.dennyzhang.com/contact>
## Description :
## --
## Created : <2018-02-07>
## Updated: Time-stamp: <2018-02-08 17:10:13>
##-------------------------------------------------------------------
set -e

function valid_parameters() {
    # TODO: reduce the code duplication
    if [ -z "$vm_hostname" ]; then
        echo -e "Error: vm_hostname parameter should be given."
        exit 1
    fi
    if [ -z "$machine_flavor" ]; then
        echo -e "Error: machine_flavor parameter should be given."
        exit 1
    fi
    if [ -z "$region" ]; then
        echo -e "Error: region parameter should be given."
        exit 1
    fi
    if [ -z "$ssh_keys" ]; then
        echo -e "Error: ssh_keys parameter should be given."
        exit 1
    fi
    if [ -z "$do_token" ]; then
        echo -e "Error: do_token parameter should be given."
        exit 1
    fi

    if [ -n "$provision_folder" ] && [ ! -d "$provision_folder" ]; then
        echo -e "Error: provision_folder is given as $provision_folder. But the folder is not found"
        exit 1
    fi
}

function prepare_terraform_template() {
    cat > example.tf <<EOF
variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
 token = "\${var.do_token}"
}

resource "digitalocean_droplet" "$vm_hostname" {
 image = "$vm_image"
 name = "$vm_hostname"
 region = "$region"
 size = "$machine_flavor"
 $user_data
 ssh_keys = [$ssh_keys]
}
EOF
}

function create_vm_without_volume() {
    terraform init
    if [ -z "$provision_sh" ]; then
        user_data=""
    else
        user_data="#cloud-config\nruncmd:\n - wget -O /root/userdata.sh $provision_sh \n - bash /root/userdata.sh"
    fi

    prepare_terraform_template
    terraform apply -auto-approve --var="do_token=$do_token"
    terraform show
}

function run_provision_folder() {
    # scp provision folder to root
    # Then run all bash script
    local provision_folder=${1?}
    echo "scp $provision_folder folder to /root of the VM"
}
################################################################################
valid_parameters

terraform_task_id=${1?}
terraform_tf_file=${2?}
provision_folder=${3:-""}
export vm_image="ubuntu-14-04-x64"
export working_dir="."

mkdir -p "$working_dir/$terraform_task_id"
# cp "$terraform_tf_file" "$working_dir/$terraform_task_id/"
cd "$working_dir/$terraform_task_id"

create_vm_without_volume
# TODO: support creating VM with volumes

if [ -n "$provision_folder" ]; then
    run_provision_folder "$provision_folder"
fi
## File: terraform_create.sh ends
