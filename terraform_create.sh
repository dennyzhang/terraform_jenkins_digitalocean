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
## Updated: Time-stamp: <2018-02-07 19:35:28>
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
}

function create_vm_without_volume() {
    terraform init
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
 user_data = "#cloud-config\nruncmd:\n - wget -O /root/userdata.sh $provision_sh \n - bash /root/mdm_os_provision.sh"
 ssh_keys = [$ssh_keys]
}
EOF
    terraform apply --var="do_token=$do_token"
    # terraform show
}

################################################################################
valid_parameters

terraform_task_id=${1?}
terraform_tf_file=${2?}
export vm_image="ubuntu-14-04-x64"
export working_dir="."

mkdir -p "$working_dir/$terraform_task_id"
# cp "$terraform_tf_file" "$working_dir/$terraform_task_id/"
cd "$working_dir/$terraform_task_id"

create_vm_without_volume
## File: terraform_create.sh ends
