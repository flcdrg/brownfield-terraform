# The Problem

* Three separate environments in Azure (Dev/Test/Prod)
* Some automation has been used, but not consistently
* There are obvious manual configuration changes present

---

# Dev

| **Name** | **Type** |
|------|------|
|<img src="/10245-icon-service-Key-Vaults.svg" align="center" style="display:inline"> kv-bf-dev-je7v-aue      | Microsoft.KeyVault/vaults|
|<img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfdev | Microsoft.Storage/storageAccounts|
|<img src="/10086-icon-service-Storage-Accounts.svg" align="center" style="display:inline"> stbfdevtf       | Microsoft.Storage/storageAccounts|
|<img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-dev-australiaeast | Microsoft.Web/serverFarms|
|<img src="/00046-icon-service-App-Service-Plans.svg" align="center" style="display:inline"> plan-brownfield-web-dev-australiaeast   | Microsoft.Web/serverFarms|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f1-dev-aue      | Microsoft.Web/sites|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f2-dev-aue      | Microsoft.Web/sites|
|<img src="/10029-icon-service-Function-Apps.svg" align="center" style="display:inline"> func-brownfield-f3-dev-aue      | Microsoft.Web/sites|
|app-brownfield-dev-australiaeast        | Microsoft.Web/sites|

---

# Test

---

# Prod
