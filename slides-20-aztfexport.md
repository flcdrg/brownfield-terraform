---
layout: section
---

# `aztfexport`

---

# Azure Export for Terraform

* <QRCode :width="150" :height="150" color="blue" value="https://learn.microsoft.com/en-us/azure/developer/terraform/azure-export-for-terraform/export-terraform-overview?WT.mc_id=DOP-MVP-5001655" bottomAdjust="-2em" />
* Console app with optional interactive UI
* Run from empty directory

---

# Launch UI targeting resource group

Start with the Dev environment

```bash
aztfexport resource-group rg-brownfield-dev-australiaeast
```

---
layout: image
title: aztfexport Initializing
image: ./slides/aztfexport/aztfexport-initializing.png
---

<!-- aztfexport initialising screenshot -->

---
layout: image
title: Waiting...
image: ./slides/aztfexport/hourglass.gif
---

<!-- hourglass animation -->

---
layout: image
image: ./slides/aztfexport/aztfexport-ui.png
---

<!-- Screenshot of aztfexport UI.

You can edit the items here. But there are a lot of items. Easier to open JSON file in editor and do it there. 

- Can delete items
- Hit 's' to save mapping file
- 'Show recommendation' just shows resource type of current item

-->

---

# Or use the CLI to generate JSON

```bash {1|2|3|4|5|6|7|*}
aztfexport resource-group \
    --provider-version 4.22.0 \
    --include-role-assignment \
    --non-interactive \
    --continue \
    --overwrite \
    --generate-mapping-file \
    rg-brownfield-dev-australiaeast
```

<!-- 
- AzureRM provider version
- Include role assignments
- Don't display UI
- Continue on any errors
- Overwrite any existing files
- Generate the mapping file

-->

---

# `aztfexportResourceMapping.json`

```json {*}{maxHeight: '80%' }
{
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast",
        "resource_type": "azurerm_resource_group",
        "resource_name": "res-0"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Authorization/roleAssignments/9f3ff1a3-d317-4f8e-b96e-10246c02137e": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Authorization/roleAssignments/9f3ff1a3-d317-4f8e-b96e-10246c02137e",
        "resource_type": "azurerm_role_assignment",
        "resource_name": "res-1"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Authorization/roleAssignments/ae20985a-0803-4049-b990-27c9aa231cfb": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Authorization/roleAssignments/ae20985a-0803-4049-b990-27c9aa231cfb",
        "resource_type": "azurerm_role_assignment",
        "resource_name": "res-2"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue",
        "resource_type": "azurerm_key_vault",
        "resource_name": "res-3"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/1d8f1d76-4640-4ff8-93eb-765b18aa053e": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/1d8f1d76-4640-4ff8-93eb-765b18aa053e",
        "resource_type": "azurerm_role_assignment",
        "resource_name": "res-4"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/2d6a5603-526c-482a-9bf0-1283f3f6645f": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/2d6a5603-526c-482a-9bf0-1283f3f6645f",
        "resource_type": "azurerm_role_assignment",
        "resource_name": "res-5"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/46ee264c-d863-47d7-aade-483b4f67eda1": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/providers/Microsoft.Authorization/roleAssignments/46ee264c-d863-47d7-aade-483b4f67eda1",
        "resource_type": "azurerm_role_assignment",
        "resource_name": "res-6"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue/secrets/super-secret": {
        "resource_id": "https://kv-bf-dev-je7v-aue.vault.azure.net/secrets/super-secret/31832b009fb24d688449eaa1a7b70e38",
        "resource_type": "azurerm_key_vault_secret",
        "resource_name": "res-7"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev",
        "resource_type": "azurerm_storage_account",
        "resource_name": "res-8"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/blobServices/default/containers/azure-webjobs-hosts": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/blobServices/default/containers/azure-webjobs-hosts",
        "resource_type": "azurerm_storage_container",
        "resource_name": "res-10"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/blobServices/default/containers/azure-webjobs-secrets": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/blobServices/default/containers/azure-webjobs-secrets",
        "resource_type": "azurerm_storage_container",
        "resource_name": "res-11"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/queueServices/default": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev",
        "resource_type": "azurerm_storage_account_queue_properties",
        "resource_name": "res-13"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdev/tableServices/default/tables/AzureFunctionsDiagnosticEvents202503": {
        "resource_id": "https://stbfdev.table.core.windows.net/Tables('AzureFunctionsDiagnosticEvents202503')",
        "resource_type": "azurerm_storage_table",
        "resource_name": "res-15"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf",
        "resource_type": "azurerm_storage_account",
        "resource_name": "res-16"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf/blobServices/default/containers/tfstate": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf/blobServices/default/containers/tfstate",
        "resource_type": "azurerm_storage_container",
        "resource_name": "res-18"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf/queueServices/default": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Storage/storageAccounts/stbfdevtf",
        "resource_type": "azurerm_storage_account_queue_properties",
        "resource_name": "res-20"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-dev-australiaeast",
        "resource_type": "azurerm_service_plan",
        "resource_name": "res-22"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-web-dev-australiaeast": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-web-dev-australiaeast",
        "resource_type": "azurerm_service_plan",
        "resource_name": "res-23"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast",
        "resource_type": "azurerm_linux_web_app",
        "resource_name": "res-24"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast/hostNameBindings/app-brownfield-dev-australiaeast.azurewebsites.net": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast/hostNameBindings/app-brownfield-dev-australiaeast.azurewebsites.net",
        "resource_type": "azurerm_app_service_custom_hostname_binding",
        "resource_name": "res-28"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue",
        "resource_type": "azurerm_linux_function_app",
        "resource_name": "res-53"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue/hostNameBindings/func-brownfield-f1-dev-aue.azurewebsites.net": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f1-dev-aue/hostNameBindings/func-brownfield-f1-dev-aue.azurewebsites.net",
        "resource_type": "azurerm_app_service_custom_hostname_binding",
        "resource_name": "res-57"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f2-dev-aue": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f2-dev-aue",
        "resource_type": "azurerm_linux_function_app",
        "resource_name": "res-106"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f2-dev-aue/hostNameBindings/func-brownfield-f2-dev-aue.azurewebsites.net": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f2-dev-aue/hostNameBindings/func-brownfield-f2-dev-aue.azurewebsites.net",
        "resource_type": "azurerm_app_service_custom_hostname_binding",
        "resource_name": "res-110"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f3-dev-aue": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f3-dev-aue",
        "resource_type": "azurerm_linux_function_app",
        "resource_name": "res-159"
    },
    "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f3-dev-aue/hostNameBindings/func-brownfield-f3-dev-aue.azurewebsites.net": {
        "resource_id": "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/func-brownfield-f3-dev-aue/hostNameBindings/func-brownfield-f3-dev-aue.azurewebsites.net",
        "resource_type": "azurerm_app_service_custom_hostname_binding",
        "resource_name": "res-163"
    }
}
```

---

# Edit mapping file

* Remove Resource Group
* Remove any other unwanted resources
* Remove default resources (eg storage queue, table etc) if not used
* Make sure JSON is valid (eg. remove trailing commas)

---

# Generate Terraform from mapping file

Create a new directory to run this command from.

```bash {1|2|3|4|5|6|*}
aztfexport mapping-file \
    --provider-version 4.22.0 \
    --non-interactive \
    --hcl-only \
    --generate-import-block \
    ../aztfexportResourceMapping.json
```

<!--
- hcl-only (Only generate .tf files, not state file etc)
- also generate imports for resources
-->

---

# Rinse and repeat

* For Test and Prod (and any other environments)
* Look for any new resources that don't exist in dev

---

# Alternatives

* Azure Portal export to Terraform (currently private preview)
