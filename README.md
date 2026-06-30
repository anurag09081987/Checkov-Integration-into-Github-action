# Checkov Integration into GitHub Actions for Terraform (Azure)

## Project Overview

This project demonstrates how to integrate **Checkov** with **GitHub Actions** to perform Infrastructure as Code (IaC) security scanning before deploying Azure infrastructure using Terraform.

The pipeline ensures that Terraform code is validated for security best practices before infrastructure is provisioned.

---

## Architecture

```
Developer
    │
    ▼
Git Push (main branch)
    │
    ▼
GitHub Actions
    │
    ├── Checkout Repository
    ├── Checkov Security Scan
    ├── Terraform Init
    ├── Terraform Validate
    ├── Terraform Format
    ├── Terraform Plan
    │
    ▼
Manual Approval (Environment: Production)
    │
    ▼
Terraform Apply
    │
    ▼
Azure Resources Created
```

---

## Repository Structure

```
.
├── .github
│   └── workflows
│       └── dev.yml
│
├── azure_resources
│   ├── provider.tf
│   └── main.tf
│
└── README.md
```

---

## Azure Resources Created

The Terraform code provisions:

- Azure Resource Group
- Azure Storage Account

---

## GitHub Actions Workflow

The workflow consists of two jobs.

### Job 1 : Security-Tool-CheckoV

This job performs:

- Checkout Source Code
- Checkov Security Scan
- Terraform Installation
- Azure Login
- Terraform Init
- Terraform Validate
- Terraform Format Check
- Terraform Plan

---

### Job 2 : Resource-Provision

This job executes only after the first job succeeds.

Steps:

- Checkout Repository
- Terraform Installation
- Azure Login
- Terraform Init
- Terraform Apply

The deployment is protected using a **Production Environment**, allowing manual approval before infrastructure is provisioned.

---

## GitHub Secrets Required

The following repository secrets must be configured.

| Secret | Description |
|----------|-------------|
| AZURE_CLIENT_ID | Azure Service Principal Client ID |
| AZURE_TENANT_ID | Azure Tenant ID |
| AZURE_SUBSCRIPTION_ID | Azure Subscription ID |

---

## Checkov Integration

Checkov scans Terraform files before deployment.

Current configuration:

```yaml
- name: CheckOv
  uses: bridgecrewio/checkov-action@v12.1347.0
  with:
    directory: ./azure_resources
    
```

# Security Issues Identified by Checkov

During Checkov integration, several security findings were identified and resolved.

---

## 1. Public Network Access

### Issue

The Storage Account was accessible over the public network.

### Risk

Anyone with network access could attempt to connect to the storage account.

### Solution

Configured Storage Account network rules:

```terraform
network_rules {
    default_action = "Deny"

    bypass = [
        "AzureServices"
    ]
}
```

---

## 2. Minimum TLS Version

### Issue

Storage Account allowed older TLS versions.

### Risk

Older TLS versions contain known security vulnerabilities.

### Solution

Configured:

```terraform
min_tls_version = "TLS1_2"
```

---

## 3. HTTPS Only

### Issue

HTTP traffic was permitted.

### Risk

Data transmitted over HTTP is unencrypted.

### Solution

Enabled HTTPS only:

```terraform
https_traffic_only_enabled = true
```

---

## 4. Storage Logging

### Issue

Storage logging was disabled.

### Risk

Security investigations and auditing become difficult without logs.

### Solution

Enabled Queue logging:

```terraform
queue_properties {
    logging {
        delete = true
        read = true
        write = true
        version = "1.0"
        retention_policy_days = 10
    }
}
```

---

# Remaining Security Recommendations

The current project is suitable for learning GitHub Actions and Checkov integration.

For production environments, consider implementing the following:

- Enable Storage Account Encryption using Customer Managed Keys (CMK)
- Enable Microsoft Defender for Storage
- Enable Blob Versioning
- Enable Soft Delete
- Enable Private Endpoint
- Disable Public Network Access completely
- Enable Diagnostic Settings
- Enable Storage Lifecycle Management
- Use Azure Key Vault for secrets
- Configure Remote Backend using Azure AD authentication instead of hardcoded values
- Store Terraform variables separately using `.tfvars`

---

## Workflow Features

✔ Infrastructure as Code (Terraform)

✔ GitHub Actions CI/CD

✔ Checkov Security Scanning

✔ Azure OIDC Login

✔ Terraform Validation

✔ Terraform Planning

✔ Environment Approval

✔ Terraform Deployment

---

## Technologies Used

- Terraform
- Microsoft Azure
- GitHub Actions
- Checkov
- Azure Resource Manager (ARM)

---

## Future Improvements

- Terraform Destroy Workflow
- Pull Request Validation
- Multi-Environment Deployment (Dev, QA, Prod)
- Reusable GitHub Workflows
- Terraform Modules
- SonarCloud Integration
- Trivy Integration
- Slack / Teams Notifications
- Automated Security Gates

---

## Author

Anurag Chauhan

Learning Azure DevOps, Terraform, GitHub Actions and Cloud Security Automation.
