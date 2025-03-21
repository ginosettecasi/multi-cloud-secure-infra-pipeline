# 🌐 Multi-Cloud Secure Infrastructure Pipeline with Terraform & GitHub Actions

This project demonstrates a fully automated **DevSecOps pipeline** for provisioning secure cloud infrastructure across **AWS** and **Azure** using **Terraform**, **GitHub Actions**, **Checkov**, and **Snyk**.

Everything is deployed automatically from GitHub — no local CLI required.

---

## 🧠 Purpose

Designed to showcase end-to-end security automation and infrastructure as code for a DevSecOps role, this project:

- Provisions multi-cloud infrastructure using **Terraform**
- Lints IaC using **Checkov**
- Performs security scans with **Snyk**
- Uses **GitHub Actions** for full CI/CD
- Requires no manual deployment or local interaction

---

## 🔐 Tools Used

| Tool           | Purpose                                       |
|----------------|-----------------------------------------------|
| Terraform      | Provision secure AWS & Azure infrastructure   |
| GitHub Actions | CI/CD automation                              |
| Checkov        | IaC security linting                          |
| Snyk           | Dependency scanning                           |
| AWS & Azure    | Multi-cloud environments (Free Tier)          |

---

## 🚀 Features

- Secure-by-default infrastructure (least privilege IAM, NSGs, VPC)
- Terraform IaC for **AWS VPC**, **Azure Resource Group**, and **Security Groups**
- Pre-merge checks using **Checkov**
- GitHub Actions pipeline with **Terraform plan/apply**
- Secrets managed via GitHub Secrets
- Optional approval gates for production deployment

---

## 📁 Project Structure

multi-cloud-secure-infra-pipeline/ ├── .github/workflows/ci.yml # GitHub Actions pipeline ├── terraform/aws/main.tf # AWS Terraform IaC ├── terraform/aws/variables.tf # Terraform variables ├── .pre-commit-config.yaml # Linting automation ├── snyk.yml # Optional: Snyk CLI scanning └── README.md # Project overview


---

## 📡 Pipeline Status

✅ Pipeline is live and automatically runs Terraform security scans and deployments to AWS.

---

## 🛡️ Security Remediation & DevSecOps Strategy

This project was built to align with real-world **DevSecOps principles**, not just to automate infrastructure — but to **enforce secure-by-default configurations** and **prevent high-risk deployments** through CI/CD.

### ✅ How the Pipeline Remediates High-Risk Issues

The GitHub Actions pipeline integrates **Checkov**, which performs security analysis on Terraform code before deployment. During development, the pipeline identified several high-risk misconfigurations, including:

- Security Groups allowing SSH and HTTP from `0.0.0.0/0`
- Egress rules that allowed all traffic on all ports
- CloudWatch log retention being too short
- Lack of VPC Flow Logs for network auditing

These were **proactively remediated** in code:

| Issue | Remediation |
|-------|-------------|
| SSH & HTTP from 0.0.0.0/0 | Replaced with `${var.trusted_ip}/32`, pulled from **GitHub Secrets** |
| Unrestricted egress | Limited to **web traffic on private CIDRs** |
| Short log retention | Increased to **365 days** |
| Missing VPC Flow Logs | Enabled with **IAM role & CloudWatch** integration |

Additionally, non-critical findings (e.g., KMS encryption for low-sensitivity log groups or default VPC SG settings) were documented with `checkov:skip` and clear justifications in code. This reflects a **realistic DevSecOps maturity model**:

- 📌 Fix what matters most  
- 📝 Document accepted risks  
- 🔐 Keep everything versioned and auditable

### 🧠 Additional Highlights

- Security scanning is embedded directly into CI/CD — no manual steps
- High-risk findings are blocked automatically before apply
- Remediation decisions are **transparent, documented, and intentional**
- Sensitive inputs like IP addresses are stored securely in **GitHub Secrets**

This approach mirrors how real security-focused teams operate — blending **automation, security enforcement, and risk context** to deliver reliable, secure cloud infrastructure.

---

**Created by [Gino A. Settecasi](https://ginosettecasi.github.io)** — Portfolio project for DevSecOps
