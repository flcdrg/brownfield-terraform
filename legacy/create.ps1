# Create resource groups
az group create --name rg-brownfield-dev-australiaeast --location australiaeast
az group create --name rg-brownfield-test-australiaeast --location australiaeast
az group create --name rg-brownfield-prod-australiaeast --location australiaeast

# Create Key Vaults (24 characters max)
az keyvault create --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --location australiaeast --retention-days 7 --enable-rbac-authorization false
az keyvault create --name kv-bf-test-u48x-aue --resource-group rg-brownfield-test-australiaeast --location australiaeast --retention-days 7 --enable-rbac-authorization false
az keyvault create --name kv-bf-prod-0meq-aue --resource-group rg-brownfield-prod-australiaeast --location australiaeast --retention-days 7 --enable-rbac-authorization false

# Create Storage Accounts
az storage account create --name stbfdev --resource-group rg-brownfield-dev-australiaeast --location australiaeast --sku Standard_LRS --access-tier Hot
az storage account create --name stbftest --resource-group rg-brownfield-test-australiaeast --location australiaeast --sku Standard_LRS --https-only false
az storage account create --name stbfprod --resource-group rg-brownfield-prod-australiaeast --location australiaeast --sku Standard_LRS

# Create Storage Accounts for TF state
az storage account create --name stbfdevtf --resource-group rg-brownfield-dev-australiaeast --location australiaeast --sku Standard_LRS
az storage account create --name stbftesttf --resource-group rg-brownfield-test-australiaeast --location australiaeast --sku Standard_LRS
az storage account create --name stbfprodtf --resource-group rg-brownfield-prod-australiaeast --location australiaeast --sku Standard_LRS

# Create App Service Plans
az appservice plan create --name plan-brownfield-dev-australiaeast --resource-group rg-brownfield-dev-australiaeast --location australiaeast --sku B1 --is-linux
#az appservice plan create --name plan-brownfield-test-australiaeast --resource-group rg-brownfield-test-australiaeast --location australiaeast --sku B1 --is-linux
az appservice plan create --name plan-brownfield-prod-australiaeast --resource-group rg-brownfield-prod-australiaeast --location australiaeast --sku S1 --is-linux

# Create Azure Functions
az functionapp create --name func-brownfield-f1-dev-aue --resource-group rg-brownfield-dev-australiaeast --storage-account stbfdev --plan plan-brownfield-dev-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-f2-dev-aue --resource-group rg-brownfield-dev-australiaeast --storage-account stbfdev --plan plan-brownfield-dev-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-f3-dev-aue --resource-group rg-brownfield-dev-australiaeast --storage-account stbfdev --plan plan-brownfield-dev-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'

# No Functions in Test!

# Create Azure Functions for Prod
az functionapp create --name func-brownfield-app-f1-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-app-f2-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-app-f3-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'

# Key vault access policies (spn is Enterprise Application's Application ID)
## David has full access
az keyvault set-policy --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --upn david.gardiner@sixpivot.com.au --certificate-permissions all --key-permissions all --secret-permissions all --storage-permissions all
## Pipeline SPN has full access
az keyvault set-policy --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --spn 00000000-0000-0000-0000-000000000002 --certificate-permissions all --key-permissions all --secret-permissions all --storage-permissions all

## Function func-brownfield-f1-dev-aue has read access to secrets (spn is Enterprise Application's Application ID)
az keyvault set-policy --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --spn 00000000-0000-0000-0000-000000000003 --secret-permissions get list
az keyvault set-policy --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --spn 00000000-0000-0000-0000-000000000004 --secret-permissions get list
az keyvault set-policy --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --spn 00000000-0000-0000-0000-000000000005 --secret-permissions get list

# Key vault also has role assignments (even though the above policies should be enough)
az role assignment create --assignee-object-id 00000000-0000-0000-0000-000000000006 --role "Reader" --assignee-principal-type ServicePrincipal --scope /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue
az role assignment create --assignee-object-id 00000000-0000-0000-0000-000000000007 --role "Reader" --assignee-principal-type ServicePrincipal --scope /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue
az role assignment create --assignee-object-id 00000000-0000-0000-0000-000000000008 --role "Reader" --assignee-principal-type ServicePrincipal --scope /subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.KeyVault/vaults/kv-bf-dev-je7v-aue
