export vm_hostname="denny-vm1"

export machine_flavor="512mb"
export region="sfo2"
export ssh_keys="XXXX"
export provision_sh="https://raw.githubusercontent.com/DennyZhang/dennytest/master/hashicorp_terraform/userdata.sh"


terraform init

terraform apply --var="do_token=XXX"
terraform show

# destroy
terraform destroy -force --var="do_token=XXX"
