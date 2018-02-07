# Basic Intro
<a href="https://github.com/DennyZhang?tab=followers"><img align="right" width="200" height="183" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/fork_github.png" /></a>

[![PRs Welcome](https://img.shields.io/badge/PRs-welcome-brightgreen.svg)](http://makeapullrequest.com) [![LinkedIn](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/linkedin.png)](https://www.linkedin.com/in/dennyzhang001) <a href="https://www.dennyzhang.com/slack" target="_blank" rel="nofollow"><img src="http://slack.dennyzhang.com/badge.svg" alt="slack"/></a> [![Github](https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/github.png)](https://github.com/DennyZhang)

File me [tickets](https://github.com/DennyZhang/popular-github-template/issues) or star [the repo](https://github.com/DennyZhang/popular-github-template).

Define Jenkins job to create and provision digitalocean VMs by terraform

Table of Contents
=================
<a href="https://www.dennyzhang.com"><img align="right" width="201" height="268" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/denny_201706.png"></a>

   * [Basic Intro](#basic-intro)
   * [Create VM With pures bash](#create-vm-with-pures-bash)
   * [Create VM With Jenkins job](#create-vm-with-jenkins-job)

# Create VM With pures bash
- 1. Prepare parameters
```
export vm_hostname="denny-vm1"
export machine_flavor="512mb"
export region="sfo2"

# export ssh_keys="XXXX"
# export do_token="XXX"
# export provision_sh="https://raw.githubusercontent.com/DennyZhang/dennytest/master/hashicorp_terraform/userdata.sh"
```

- 2.1 Provision a vm without volumes
```
export terraform_task_id="$vm_hostname"
bash -e terraform_do_create.sh "$terraform_task_id" "vm_without_volume_example.tf"
```

- 2.2 Provision a vm with volumes
```
export terraform_task_id="$vm_hostname"
bash -e terraform_do_create.sh "$terraform_task_id" "vm_with_volume_example.tf"
```

- 3. [Optional] Destroy
```
export terraform_task_id="$vm_hostname"
bash -e terraform_do_destroy.sh "$terraform_task_id"
```

# Create VM With Jenkins job
![CreateDigitalOceanVM_job.png](https://raw.githubusercontent.com/dennyzhang/terraform_jenkins_digitalocean/master/CreateDigitalOceanVM_job.png)

jenkins_job/config.xml: [here](jenkins_job/config.xml)

- License

Code is licensed under [MIT License](https://www.dennyzhang.com/wp-content/mit_license.txt).
<a href="https://www.dennyzhang.com"><img align="right" width="185" height="37" src="https://raw.githubusercontent.com/USDevOps/mywechat-slack-group/master/images/dns_small.png"></a>
