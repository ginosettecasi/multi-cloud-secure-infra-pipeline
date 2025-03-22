# 🌐 Multi-Cloud Secure Infrastructure Pipeline with Terraform & GitHub Actions

![Terraform](https://img.shields.io/badge/Terraform-AWS-blue?logo=terraform)
![CI](https://github.com/ginosettecasi/multi-cloud-secure-infra-pipeline/actions/workflows/ci.yml/badge.svg)
![Security Scans](https://img.shields.io/badge/Security%20Scans-Snyk%20%2B%20Checkov%20%2B%20tfsec-green)

This project demonstrates a fully automated **DevSecOps pipeline** for provisioning secure cloud infrastructure across **AWS** and (future) Azure using **Terraform**, **GitHub Actions**, **Checkov**, and **Snyk**.

Everything is deployed automatically from GitHub — no local CLI required.

---

## 🧠 Purpose

Designed to showcase end-to-end security automation and infrastructure as code for a DevSecOps role, this project:

- Provisions multi-cloud infrastructure using **Terraform**
- Lints IaC using **Checkov**
- Performs security scans with **Snyk** and **tfsec**
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
| tfsec          | Deep Terraform security analysis              |
| AWS & Azure    | Multi-cloud environments (Free Tier)          |

---

## 🚀 Features

- Secure-by-default infrastructure (least privilege IAM, NSGs, VPC)
- Terraform IaC for **AWS VPC**, **Security Groups**, **EC2**
- Pre-merge checks using **Checkov**
- Security scanning with **Snyk** and **tfsec**
- GitHub Actions pipeline with **Terraform plan/apply**
- Secrets managed via GitHub Secrets
- Optional approval gates for production deployment

---

## 📁 Project Structure

multi-cloud-secure-infra-pipeline/  
├── .github/workflows/ci.yml            # GitHub Actions pipeline  
├── terraform/aws/main.tf              # AWS Terraform (VPC, SG, flow logs)  
├── terraform/aws/ec2.tf               # AWS EC2 instance attached to SG  
├── terraform/aws/variables.tf         # Terraform variables  
├── .pre-commit-config.yaml            # Linting automation (optional)  
├── snyk.yml                           # Optional: Snyk CLI scanning  
├── terraform/aws/reports/             # Generated IaC security scan reports  
└── README.md                          # Project documentation

---

## 📡 Pipeline Status

✅ Pipeline is live and automatically runs:

- Checkov linting
- Snyk IaC scanning
- tfsec Terraform security analysis
- Terraform Plan / Apply (with approval)
- Infrastructure deployment to AWS

---

## 📄 Sample Security Scan Results

After every CI run, the pipeline generates **SARIF** and **JSON** reports from Checkov, Snyk, and tfsec. These reports are automatically uploaded to a **private S3 bucket** for storage and review.

> 🔒 While the bucket is private, sample report contents are shown below:

### 🧪 Sample: Snyk IaC Report (JSON excerpt)
```json
{
  "infrastructureAsCodeIssues": [
    {
      "id": "terraform/aws/security-group/open-ingress",
      "title": "Security Group allows open ingress",
      "severity": "high",
      "path": "terraform/aws/main.tf"
    },
    {
      "id": "terraform/aws/cloudwatch/no-log-retention",
      "title": "Missing log retention",
      "severity": "medium",
      "path": "terraform/aws/main.tf"
    }
  ]
}
```

### 🧪 Sample: Checkov SARIF (Readable Summary)
```
Rule ID          File                    Severity   Message
CKV_AWS_24       main.tf                 HIGH       Ensure no hardcoded AWS credentials
CKV_AWS_158      main.tf                 MEDIUM     Ensure log group retention is set
```

### 🧪 Sample: tfsec Output (Readable Summary)
```
Result          File             Rule ID             Description
FAILED          main.tf          AWS002              Security group allows 0.0.0.0/0 ingress
PASSED          main.tf          AWS017              IAM policy does not allow full admin access
```

These results are stored in:
- `terraform/aws/reports/checkov.sarif`
- `terraform/aws/reports/snyk.sarif`, `snyk.json`
- `terraform/aws/reports/tfsec.sarif`

---

## 🧩 Step 4: Snyk IaC Integration

To strengthen security posture and showcase real-world AppSec integration, this project adds **Snyk IaC scanning** directly into GitHub Actions.

### 🔍 What Snyk Scans For:
- Misconfigured security rules
- Privilege escalation risks
- Open ingress/egress patterns
- Missing encryption or logging
- Cloud infrastructure risks in Terraform

### 🧰 Technical Details:
- **Runs before Terraform apply**
- Configured to **fail on medium or higher issues**
- Outputs both **SARIF** (for GitHub Advanced Security) and **JSON** logs
- Authenticated via GitHub Secrets using `SNYK_TOKEN`

This mirrors how engineering teams catch issues **before deployment**, ensuring compliance and security-by-default.

---

## 🛡️ Security Remediation & DevSecOps Strategy

This project was built to align with real-world **DevSecOps principles**, not just to automate infrastructure — but to **enforce secure-by-default configurations** and **prevent high-risk deployments** through CI/CD.

### ✅ How the Pipeline Remediates High-Risk Issues

The GitHub Actions pipeline integrates **Checkov**, **Snyk**, and **tfsec**, which perform deep static analysis of Terraform code. During development, the pipeline identified several high-risk misconfigurations, including:

- Security Groups allowing SSH and HTTP from `0.0.0.0/0`
- Egress rules that allowed all traffic on all ports
- CloudWatch log retention being too short
- Lack of VPC Flow Logs for network auditing

These were **proactively remediated** in code:

| Issue                        | Remediation                                      |
|-----------------------------|--------------------------------------------------|
| SSH & HTTP from 0.0.0.0/0   | Replaced with `${var.trusted_ip}/32`            |
| Unrestricted egress         | Limited to **web traffic on private CIDRs**     |
| Short log retention         | Increased to **365 days**                        |
| Missing VPC Flow Logs       | Enabled with **IAM role & CloudWatch** integration |

Additionally, non-critical findings (e.g., KMS encryption for low-sensitivity log groups or default VPC SG settings) were documented with `checkov:skip` and clear justifications in code. This reflects a **realistic DevSecOps maturity model**:

- 📌 Fix what matters most  
- 📝 Document accepted risks  
- 🔐 Keep everything versioned and auditable

---

## 🧠 Highlights

- ✅ GitHub Actions-based secure CI/CD with no local dependency
- 🔐 Snyk + Checkov + tfsec catch risks pre-deployment
- ☁️ AWS infra deployed using Terraform (modular, scalable)
- 🧩 Security Groups are **actually used** by deployed EC2
- 👥 IP restrictions are secured using GitHub Secrets
- 📦 All IaC is production-grade and backed by automated security scans
- ☁️ All scan reports are securely stored in an **S3 bucket** for review

---

**Created by [Gino A. Settecasi](https://ginosettecasi.github.io)** — Portfolio project for DevSecOps Engineer

