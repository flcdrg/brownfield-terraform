# Create resource groups
az group create --name rg-brownfield-dev-australiaeast --location australiaeast
az group create --name rg-brownfield-test-australiaeast --location australiaeast
az group create --name rg-brownfield-prod-australiaeast --location australiaeast

# Create Key Vaults (24 characters max)
az keyvault create --name kv-bf-dev-je7v-aue --resource-group rg-brownfield-dev-australiaeast --location australiaeast --retention-days 7
az keyvault create --name kv-bf-test-u48x-aue --resource-group rg-brownfield-test-australiaeast --location australiaeast --retention-days 7
az keyvault create --name kv-bf-prod-0meq-aue --resource-group rg-brownfield-prod-australiaeast --location australiaeast --retention-days 7

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

# No Functions in Test

# Create Azure Functions for Prod
az functionapp create --name func-brownfield-app-f1-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-app-f2-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'
az functionapp create --name func-brownfield-app-f3-prod-aue --resource-group rg-brownfield-prod-australiaeast --storage-account stbfprod --plan plan-brownfield-prod-australiaeast --runtime dotnet-isolated --runtime-version 8 --functions-version 4 --os-type Linux --disable-app-insights true --assign-identity '[system]'