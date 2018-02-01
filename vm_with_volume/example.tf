variable "do_token" {}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = "\${var.do_token}"
}

# Create volumes
resource "digitalocean_volume" "${vm_hostname}-volume1" {
  region      = "$region"
  name        = "${vm_hostname}-volume1"
  size        = 5
  description = "volume1"
}

resource "digitalocean_volume" "${vm_hostname}-volume2" {
  region      = "$region"
  name        = "${vm_hostname}-volume2"
  size        = 5
  description = "volume2"
}

resource "digitalocean_droplet" "$vm_hostname" {
  image  = "ubuntu-14-04-x64"
  name   = "$vm_hostname"
  region = "$region"
  size   = "$machine_flavor"
  volume_ids = ["\${digitalocean_volume.${vm_hostname}-volume1.id}", "\${digitalocean_volume.${vm_hostname}-volume2.id}"]
  user_data = "#cloud-config\nruncmd:\n  - wget -O $provision_sh /tmp/userdata.sh \n  - bash /tmp/userdata.sh"
  ssh_keys = [$ssh_keys]
}