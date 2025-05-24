# 🚀 Terraform Proxmox Template with GitHub Actions

[![Terraform](https://img.shields.io/badge/Terraform-1.0+-623CE4?logo=terraform)](https://www.terraform.io/)
[![Proxmox](https://img.shields.io/badge/Proxmox-API%20Integration-orange?logo=proxmox)](https://pve.proxmox.com/wiki/Proxmox_VE_API)

> A starter template for provisioning infrastructure using Terraform + Proxmox, secured with GitHub Actions Secrets and CI automation.

---

## 🚀 How to Use This Template

### 1. Fork or clone the repository

```bash
git clone https://github.com/your-org/your-repo-name.git
cd your-repo-name
```

---

### 2. Set required GitHub secrets

In your GitHub repository settings (`Settings -> Secrets and variables -> Actions`), create the following **repository secrets**:

| Secret Name           | Description                  |
|------------------------|-------------------------------|
| `PM_API_URL`           | Proxmox API URL (e.g., `https://your-proxmox-server:8006/api2/json`) |
| `PM_API_TOKEN_ID`      | Proxmox API Token ID |
| `PM_API_TOKEN_SECRET`  | Proxmox API Token Secret |
| `PASSPHRASE` (optional) | (If needed) Passphrase for encrypted Terraform plans |

---

### 3. Project structure

```plaintext
.
├── .github/
│   └── workflows/
│       └── terraform.yml   # GitHub Actions workflow
├── main/
│   ├── main.tf             # Terraform resources
│   ├── providers.tf        # Terraform provider config
│   ├── variables.tf        # Input variable declarations
│   └── (auto-generated) secrets.auto.tfvars
└── README.md               # This file
```

---

### 4. How the GitHub Action works

- **On push**, pull request, or manual dispatch:
  - The workflow **creates** a `secrets.auto.tfvars` file containing Proxmox secrets.
  - `secrets.auto.tfvars` is placed inside the `./main/` directory (where Terraform is run).
  - Terraform reads these variables automatically without hardcoding sensitive values.

Example of generated `secrets.auto.tfvars` (not committed):

```hcl
pm_api_url          = "https://your-proxmox-server:8006/api2/json"
pm_api_token_id     = "your-token-id"
pm_api_token_secret = "your-token-secret"
```

- The action then runs:
  - `terraform init`
  - `terraform plan` or `terraform apply` depending on input or labels

---

### 5. Local Development (Optional)

If you want to test locally (without GitHub Actions):

1. Create a `secrets.auto.tfvars` file manually inside `main/`:

```hcl
pm_api_url          = "https://your-proxmox-server:8006/api2/json"
pm_api_token_id     = "your-token-id"
pm_api_token_secret = "your-token-secret"
```

2. Initialize and run Terraform:

```bash
cd main
terraform init
terraform plan
terraform apply
```

---

## 🛡️ Security Considerations

- Secrets **must not** be hardcoded into Terraform files.
- `secrets.auto.tfvars` is dynamically generated in CI and **should be excluded** via `.gitignore`.
- GitHub Secrets are encrypted at rest and only injected at runtime.

Add this to `.gitignore` if not already:

```
*.auto.tfvars
```

---

## ⚙️ Customization

You can extend this template by:
- Adding more input variables to `variables.tf`
- Creating additional Terraform modules
- Adjusting the GitHub Actions workflow for your needs
- Adding Slack, Teams, or email notifications based on apply status

---

## 📄 Example GitHub Action Inputs

You can manually dispatch a workflow run with:

| Input         | Description                     | Example |
|---------------|---------------------------------|---------|
| `command`     | Terraform command to run        | `plan` or `apply` |
| `lock`        | Optional Terraform lock control | `true` or `false` |

---

## 📢 Notes

- This repository assumes that your Proxmox server is properly configured for **API Token authentication**.
- Tested with `telmate/proxmox` provider version `3.0.1-rc8`.
- Terraform version `>= 1.0` is recommended.

---

## 📬 Questions / Issues?

If you have suggestions, questions, or issues using this template, feel free to open an issue or pull request!

---

## 🛠️ Example GitHub Workflow: Apply to Production

This workflow automatically applies Terraform changes when pushing to the `main` branch, or when triggered manually.

```yaml
name: 'Terraform - Apply to production environment'
on:
  push:
    branches:
      - main
  workflow_dispatch: # Allows manual triggering of the workflow

env:
  TF_LOG: INFO
  PM_API_URL: ${{ secrets.PM_API_URL }}
  PM_API_TOKEN_ID: ${{ secrets.PM_API_TOKEN_ID }}
  PM_API_TOKEN_SECRET: ${{ secrets.PM_API_TOKEN_SECRET }}

jobs:
  terraform:
    name: 'Terraform'
    runs-on: org-runner
    defaults:
      run:
        shell: bash
        working-directory: ./main

    steps:
      - name: Checkout
        uses: actions/checkout@v3

      - name: Write secrets to tfvars
        run: |
          cat <<EOF > secrets.auto.tfvars
          pm_api_url          = "${PM_API_URL}"
          pm_api_token_id     = "${PM_API_TOKEN_ID}"
          pm_api_token_secret = "${PM_API_TOKEN_SECRET}"
          EOF
        env:
          PM_API_URL: ${{ secrets.PM_API_URL }}
          PM_API_TOKEN_ID: ${{ secrets.PM_API_TOKEN_ID }}
          PM_API_TOKEN_SECRET: ${{ secrets.PM_API_TOKEN_SECRET }}

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v3

      - name: Terraform Init
        id: init
        run: terraform init

      - name: Terraform Apply
        run: terraform apply -auto-approve
```
#