---
layout: section
---

# The new pipeline

---

# Plan against each environment

```yaml {*|1-17|38-56|44,50|58-62|64-70|72-85|87-103}{maxHeight: '80%' }
parameters:
  - name: Environments
    displayName: "Environments - Do not change this in the UI"
    type: object
    default:
      - name: "Dev"
        backendServiceArm: "sp-brownfield-dev-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-dev-australiaeast"
        backendAzureRmStorageAccountName: "stbfdevtf"
      - name: "Test"
        backendServiceArm: "sp-brownfield-test-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-test-australiaeast"
        backendAzureRmStorageAccountName: "stbftesttf"
      - name: "Prod"
        backendServiceArm: "sp-brownfield-prod-australiaeast"
        backendAzureRmResourceGroupName: "rg-brownfield-prod-australiaeast"
        backendAzureRmStorageAccountName: "stbfprodtf"

trigger: none

pr: none

pool:
  vmImage: ubuntu-latest

jobs:
  - ${{ each Environment in parameters.Environments }}:
      - job: check_${{ Environment.name }}
        displayName: "Check ${{ Environment.name }}"
        steps:
          - checkout: self

          - task: TerraformInstaller@2
            displayName: "Terraform: Installer"
            inputs:
              terraformVersion: "latest"

          - script: |
              # Fail on errors
              set -e

              cp environment.${{ lower(Environment.name) }}.tfvars environment.auto.tfvars
            displayName: "Script: Copy environment.auto.tfvars"
            workingDirectory: legacy

          - task: TerraformCLI@2
            displayName: "Terraform: init"
            inputs:
              command: init
              workingDirectory: legacy
              backendType: azurerm
              backendServiceArm: ${{ Environment.backendServiceArm }}
              backendAzureRmResourceGroupName: ${{ Environment.backendAzureRmResourceGroupName }}
              backendAzureRmStorageAccountName: ${{ Environment.backendAzureRmStorageAccountName }}
              commandOptions: -no-color -input=false
              allowTelemetryCollection: false

          # Copy state locally, so we can modify it without affecting the remote state
          - script: |
              terraform state pull > $(Build.ArtifactStagingDirectory)/pull.tfstate
            displayName: "Script: Extract legacy state"
            workingDirectory: legacy

          - script: |
              # Fail on errors
              set -e

              cp environment.${{ lower(Environment.name) }}.tfvars environment.auto.tfvars
            displayName: "Script: Copy environment.auto.tfvars"
            workingDirectory: terraform

          - script: |
              # Write multiple lines of text to local file using bash
              cat > backend.tf <<EOF
              terraform {
                backend "local" {
                  path = "$(Build.ArtifactStagingDirectory)/pull.tfstate"
                }
              }
              EOF

              # Reset Terraform to use local backend
              terraform init -reconfigure -no-color -input=false
            displayName: "Script: Use Terraform Local Backend"
            workingDirectory: terraform

          - task: TerraformCLI@2
            displayName: "Terraform: validate"
            inputs:
              command: validate
              commandOptions: -no-color
              workingDirectory: terraform
              allowTelemetryCollection: false

          - task: TerraformCLI@2
            displayName: "Terraform: plan"
            inputs:
              command: plan
              environmentServiceName: ${{ Environment.backendServiceArm }}
              commandOptions: -no-color -input=false
              publishPlanResults: ${{ Environment.name }}
              workingDirectory: terraform
              allowTelemetryCollection: false
```

---
layout: image
image: ./slides/pipeline/pipeline-summary.png
backgroundSize: contain
---

---
layout: image
image: ./slides/pipeline/pipeline-terraform-tab.png
backgroundSize: contain
---

---

# Dev Terraform

```text {*|3|27|163}{maxHeight: '80%' }
Terraform will perform the following actions:

  # module.plan.azurerm_app_service_plan.plan will be destroyed
  # (because azurerm_app_service_plan.plan is not in configuration)
  - resource "azurerm_app_service_plan" "plan" {
      - id                           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverFarms/plan-brownfield-web-dev-australiaeast" -> null
      - is_xenon                     = false -> null
      - kind                         = "linux" -> null
      - location                     = "australiaeast" -> null
      - maximum_elastic_worker_count = 1 -> null
      - maximum_number_of_workers    = 3 -> null
      - name                         = "plan-brownfield-web-dev-australiaeast" -> null
      - per_site_scaling             = false -> null
      - reserved                     = true -> null
      - resource_group_name          = "rg-brownfield-dev-australiaeast" -> null
      - tags                         = {} -> null
      - zone_redundant               = false -> null
        # (1 unchanged attribute hidden)

      - sku {
          - capacity = 1 -> null
          - size     = "B1" -> null
          - tier     = "Basic" -> null
        }
    }

  # module.web.azurerm_app_service.appservice will be destroyed
  # (because azurerm_app_service.appservice is not in configuration)
  - resource "azurerm_app_service" "appservice" {
      - app_service_plan_id               = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/serverfarms/plan-brownfield-web-dev-australiaeast" -> null
      - app_settings                      = {
          - "SOME_KEY" = "SOME_VALUE"
        } -> null
      - client_affinity_enabled           = false -> null
      - client_cert_enabled               = false -> null
      - client_cert_mode                  = "Required" -> null
      - custom_domain_verification_id     = "C8FC399AE1421D239DD2F77E8A8663182A82256F4059D32C0EA377F76F7D2A21" -> null
      - default_site_hostname             = "app-brownfield-dev-australiaeast.azurewebsites.net" -> null
      - enabled                           = true -> null
      - https_only                        = false -> null
      - id                                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-brownfield-dev-australiaeast/providers/Microsoft.Web/sites/app-brownfield-dev-australiaeast" -> null
      - key_vault_reference_identity_id   = "SystemAssigned" -> null
      - location                          = "australiaeast" -> null
      - name                              = "app-brownfield-dev-australiaeast" -> null
      - outbound_ip_address_list          = [
          - "4.200.80.125",
          - "4.200.80.238",
          - "4.200.80.244",
          - "4.200.80.255",
          - "4.200.80.132",
          - "4.200.80.162",
          - "20.227.103.244",
          - "20.227.102.5",
          - "20.227.99.27",
          - "20.227.103.108",
          - "20.227.102.28",
          - "4.200.80.19",
          - "20.211.64.30",
        ] -> null
      - outbound_ip_addresses             = "4.200.80.125,4.200.80.238,4.200.80.244,4.200.80.255,4.200.80.132,4.200.80.162,20.227.103.244,20.227.102.5,20.227.99.27,20.227.103.108,20.227.102.28,4.200.80.19,20.211.64.30" -> null
      - possible_outbound_ip_address_list = [
          - "4.200.80.125",
          - "4.200.80.238",
          - "4.200.80.244",
          - "4.200.80.255",
          - "4.200.80.132",
          - "4.200.80.162",
          - "20.227.103.244",
          - "20.227.102.5",
          - "20.227.99.27",
          - "20.227.103.108",
          - "20.227.102.28",
          - "4.200.80.19",
          - "4.200.80.24",
          - "20.227.97.19",
          - "4.200.80.44",
          - "4.200.80.81",
          - "4.200.80.82",
          - "4.200.80.84",
          - "20.227.100.133",
          - "20.227.102.135",
          - "4.200.80.101",
          - "4.200.80.104",
          - "4.200.80.112",
          - "4.200.80.115",
          - "4.200.80.164",
          - "4.200.80.177",
          - "4.200.80.183",
          - "4.200.80.207",
          - "4.200.80.212",
          - "4.200.80.232",
          - "20.211.64.30",
        ] -> null
      - possible_outbound_ip_addresses    = "4.200.80.125,4.200.80.238,4.200.80.244,4.200.80.255,4.200.80.132,4.200.80.162,20.227.103.244,20.227.102.5,20.227.99.27,20.227.103.108,20.227.102.28,4.200.80.19,4.200.80.24,20.227.97.19,4.200.80.44,4.200.80.81,4.200.80.82,4.200.80.84,20.227.100.133,20.227.102.135,4.200.80.101,4.200.80.104,4.200.80.112,4.200.80.115,4.200.80.164,4.200.80.177,4.200.80.183,4.200.80.207,4.200.80.212,4.200.80.232,20.211.64.30" -> null
      - resource_group_name               = "rg-brownfield-dev-australiaeast" -> null
      - site_credential                   = [
          - {
              - password = "zPtiYJlJ4xYFkFnY7KACK453sdbouD0g1GmFdzEnpDa0E7fGpswTB2Nsl9T0"
              - username = "$app-brownfield-dev-australiaeast"
            },
        ] -> null
      - tags                              = {} -> null

      - auth_settings {
          - additional_login_params        = {} -> null
          - allowed_external_redirect_urls = [] -> null
          - enabled                        = false -> null
          - token_refresh_extension_hours  = 0 -> null
          - token_store_enabled            = false -> null
            # (4 unchanged attributes hidden)
        }

      - logs {
          - detailed_error_messages_enabled = false -> null
          - failed_request_tracing_enabled  = false -> null

          - application_logs {
              - file_system_level = "Off" -> null
            }

          - http_logs {
            }
        }

      - site_config {
          - acr_use_managed_identity_credentials = false -> null
          - always_on                            = false -> null
          - default_documents                    = [] -> null
          - dotnet_framework_version             = "v4.0" -> null
          - ftps_state                           = "FtpsOnly" -> null
          - http2_enabled                        = false -> null
          - ip_restriction                       = [] -> null
          - linux_fx_version                     = "DOTNETCORE:6.0" -> null
          - local_mysql_enabled                  = false -> null
          - managed_pipeline_mode                = "Integrated" -> null
          - min_tls_version                      = "1.0" -> null
          - number_of_workers                    = 1 -> null
          - remote_debugging_enabled             = false -> null
          - remote_debugging_version             = "VS2022" -> null
          - scm_ip_restriction                   = [] -> null
          - scm_type                             = "None" -> null
          - scm_use_main_ip_restriction          = false -> null
          - use_32_bit_worker_process            = false -> null
          - vnet_route_all_enabled               = false -> null
          - websockets_enabled                   = false -> null
            # (10 unchanged attributes hidden)

          - cors {
              - allowed_origins     = [] -> null
              - support_credentials = false -> null
            }
        }

      - source_control {
          - branch             = "master" -> null
          - manual_integration = false -> null
          - rollback_enabled   = false -> null
          - use_mercurial      = false -> null
            # (1 unchanged attribute hidden)
        }
    }

Plan: 0 to add, 0 to change, 2 to destroy.

─────────────────────────────────────────────────────────────────────────────

Note: You didn't use the -out option to save this plan, so Terraform can't
guarantee to take exactly these actions if you run "terraform apply" now.
```
