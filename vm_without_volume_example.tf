variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "\${var.do_token}"
}

resource "digitalocean_droplet" "$vm_hostname" {
  image  = "ubuntu-14-04-x64"
  name   = "$vm_hostname"
  region = "$region"
  size   = "$machine_flavor"
  user_data = "#cloud-config\nruncmd:\n  - wget -O /root/userdata.sh $provision_sh  \n  -bash /root/userdata.sh"
  ssh_keys = [$ssh_keys]
}