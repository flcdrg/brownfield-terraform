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

In HCP Terraform:

1. New | Workspace
2. Select project
3. Click **Create**
4. Select CLI-driven workflow
5. Enter workspace name ''

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
    "subject": "organization:flcdrg:project:my-project-name:workspace:brownfield-dev-australiaeast:run_phase:plan",
    "description": "Terraform Plan",
    "audiences": [
        "api://AzureADTokenExchange"
    ]
}

And create federated credentials for your service principal. The `--id` parameter should be set to the appId that you noted previously.

```bash
az ad app federated-credential create --id xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx --parameters credential.json
```

Update the credential.json file and replace 'plan' with 'apply' (3 places). Create a second federated credential by running the above command again.

Back in HCP Terraform, set the following environment variables in your workspace

`TFC_AZURE_PROVIDER_AUTH` = true
`TFC_AZURE_RUN_CLIENT_ID` = \<appId value\>
`ARM_SUBSCRIPTION_ID` = Azure subscription id
`ARM_TENANT_ID` = Azure tenant id

Repeat this for test and prod

### In `terraform` directory

1. Run `terraform login`
2. Paste the token from the browser session into the terminal
3. Run `terraform init` to initialise the workspace locally
