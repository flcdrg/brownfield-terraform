# Importing Brownfield Azure applications into Terraform

Code from the presentation 'Order from chaos - Importing brownfield Azure applications into Terraform'

## Example brownfield infrastructure

- Multiple environments with configuration differences
  - Key Vault
  - App Services (via Terraform)
  - Action Groups
  - Role assignments
  - Storage accounts

### Environments

rg-brownfield-dev-australiaeast
rg-brownfield-test-australiaeast
rg-brownfield-prod-australiaeast

## Development notes

2. Create service principal and role assignments

    ```bash
    az ad sp create-for-rbac --name sp-brownfield-dev-australiaeast --role Contributor --scopes /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast

    az role assignment create --assignee sp-brownfield-dev-australiaeast --role "Role Based Access Control Administrator" --scope /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast
    ```

Make a note of the appID and tenant ID

Create credential.json

```json
{
    "name": "tfc-plan-credential",
    "issuer": "https://app.terraform.io",
    "subject": "organization:flcdrg:project:my-project-name:workspace:terraform-azure-sql-auditing:run_phase:plan",
    "description": "Terraform Plan",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}