# OpenShift Terrarium

> OpenShift cluster managed by Terraform.

## Getting Started

Create *terraform.tfvars* file with configuration for your ESXi server:

```ruby
esxi_server = "esxi-server.example.com"
esxi_user = "root"
esxi_password = "password"
```

Run the `terraform apply` command to create the cluster:

```shell
terraform apply -auto-approve
```


### Create Cluster


```shell
terraform plan -out okd.tfplan
terraform apply "okd.tfplan"
```

### Destroy Cluster

```shell
terraform plan -destroy -out okd.tfplan
terraform apply "okd.tfplan"
```
