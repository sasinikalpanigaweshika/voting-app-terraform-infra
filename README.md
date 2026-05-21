# Voting App - Azure Infrastructure (Terraform)

Terraform IaC to provision the full Azure infrastructure for the Voting App project.

## Infrastructure Components
- **AKS Cluster** - Kubernetes cluster with managed identity
- **ACR** - Private container registry with private endpoint
- **Azure Bastion** - Secure VM access without public IP
- **CI Runner VM** - Self-hosted Azure DevOps agent
- **VNet** - Private networking with dedicated subnets
- **Managed Identities** - Passwordless authentication for AKS and CI runner

## Architecture
- AKS pulls images from ACR using managed identity (no credentials)
- ACR accessible only via private endpoint
- CI runner pushes images to ACR using managed identity
- Bastion provides secure access to private VMs

## Usage
```bash
terraform init
terraform plan
terraform apply
```
