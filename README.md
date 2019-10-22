# laas afterbooking actions

```
terraform init
terraform plan -var ssh_hosts="<your_server_1,your_server_n>" -var ssh_key=<path_to_your_private_ssh_key_for_those_servers>
terraform apply -var ssh_hosts="<your_server_1,your_server_n>" -var ssh_key=<path_to_your_private_ssh_key_for_those_servers>
```
