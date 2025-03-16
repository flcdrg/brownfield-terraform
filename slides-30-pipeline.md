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
