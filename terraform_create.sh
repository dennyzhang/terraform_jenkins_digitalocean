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
## Updated: Time-stamp: <2018-02-08 17:43:12>
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

function get_vm_ip() {
    # TODO: add error handling
    terraform show | grep ipv4_address | awk -F'= ' '{print $2}'
}

function run_provision_folder() {
    # scp provision folder to root
    # Then run all bash script
    local provision_folder=${1?}
    local vm_ip=${2?}

    # TODO: customize the ssh key
    local ssh_key_file=${3:-"~/.ssh/id_rsa"}
    local ssh_username="root"
    local ssh_folder="/root"
    local ssh_port="22"
    echo "scp $provision_folder folder to /root of VM(vm_ip)"
    scp -P "$ssh_port" -i "$ssh_key_file" -r $provision_folder/* "$ssh_username@$vm_ip:$ssh_folder/"

    for script in $(ls -1 $provision_folder/main_*.sh); do
        script=$(basename "$script")
        echo "ssh -i $ssh_key_file -p $ssh_port $ssh_username$vm_ip \"bash -ex /root/$script\""
        ssh -i "$ssh_key_file" -p "$ssh_port" "$ssh_username@$vm_ip" bash -ex /root/$script
    done
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
    vm_ip=$(get_vm_ip)
    cd ..
    run_provision_folder "$provision_folder" "$vm_ip"
fi
## File: terraform_create.sh ends
