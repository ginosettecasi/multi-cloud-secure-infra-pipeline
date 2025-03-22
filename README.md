# 🌐 Multi-Cloud Secure Infrastructure Pipeline with Terraform & GitHub Actions

![Terraform](https://img.shields.io/badge/Terraform-Automated-blue?logo=terraform)
![GitHub Actions](https://github.com/ginosettecasi/multi-cloud-secure-infra-pipeline/actions/workflows/ci.yml/badge.svg)
![Checkov](https://img.shields.io/badge/Checkov-Pass-green?logo=checkov)
![Snyk](https://img.shields.io/badge/Snyk-Secured-critical?logo=snyk)

This project demonstrates a fully automated **DevSecOps pipeline** for provisioning secure cloud infrastructure across **AWS** and (future) Azure using **Terraform**, **GitHub Actions**, **Checkov**, and **Snyk**.

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
| Snyk           | Dependency + IaC scanning                     |
| AWS & Azure    | Multi-cloud environments (Free Tier)          |

---

## 🚀 Features

- Secure-by-default infrastructure (least privilege IAM, NSGs, VPC)
- Terraform IaC for **AWS VPC**, **Security Groups**, **EC2**
- Pre-merge checks using **Checkov**
- Security scanning with **Snyk**
- GitHub Actions pipeline with **Terraform plan/apply**
- Secrets managed via GitHub Secrets
- Optional approval gates for production deployment

---

## 📁 Project Structure

multi-cloud-secure-infra-pipeline/
├── .github/workflows/ci.yml              # GitHub Actions pipeline
├── terraform/aws/main.tf                # AWS Terraform (VPC, SG, flow logs)
├── terraform/aws/ec2.tf                 # AWS EC2 instance attached to SG
├── terraform/aws/variables.tf           # Terraform variables
├── terraform/aws/reports/               # Security scan output reports (Checkov, Snyk, tfsec)
├── .pre-commit-config.yaml              # Linting automation (optional)
├── snyk.yml                             # Optional: Snyk CLI scanning
└── README.md                            # Project documentation

---

## 🛁 Pipeline Status

✅ Pipeline is live and automatically runs:

- Checkov linting
- Snyk IaC scanning
- Terraform Plan / Apply (with approval)
- Infrastructure deployment to AWS
- 🛄 Security reports are uploaded to **S3** for persistent access

---

## 🧹 Step 4: Snyk IaC Integration

To strengthen security posture and showcase real-world AppSec integration, this project adds **Snyk IaC scanning** directly into GitHub Actions.

### 🔍 What Snyk Scans For:
- Misconfigured security rules
- Privilege escalation risks
- Open ingress/egress patterns
- Missing encryption or logging
- Cloud infrastructure risks in Terraform

### 🧠 Technical Details:
- **Runs before Terraform apply**
- Configured to **fail on medium or higher issues**
- Outputs both **SARIF** (for GitHub Advanced Security) and **JSON** logs
- Authenticated via GitHub Secrets using `SNYK_TOKEN`

This mirrors how engineering teams catch issues **before deployment**, ensuring compliance and security-by-default.

---

## 🛡️ Security Remediation & DevSecOps Strategy

This project was built to align with real-world **DevSecOps principles**, not just to automate infrastructure — but to **enforce secure-by-default configurations** and **prevent high-risk deployments** through CI/CD.

### ✅ How the Pipeline Remediates High-Risk Issues

The GitHub Actions pipeline integrates **Checkov** and **Snyk**, which perform deep static analysis of Terraform code. During development, the pipeline identified several high-risk misconfigurations, including:

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
- 🗒️ Document accepted risks  
- 🔐 Keep everything versioned and auditable

---

## 🧠 Highlights

- ✅ GitHub Actions-based secure CI/CD with no local dependency
- 🔐 Snyk + Checkov catch risks pre-deployment
- ☁️ AWS infra deployed using Terraform (modular, scalable)
- 🧹 Security Groups are **actually used** by deployed EC2
- 👥 IP restrictions are secured using GitHub Secrets
- 📦 All IaC is production-grade and ready to scale to Azure or GCP

---

**Created by [Gino A. Settecasi](https://ginosettecasi.github.io)** — Portfolio project for DevSecOps Engineer

