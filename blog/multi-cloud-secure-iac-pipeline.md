# 🔐 Building a Multi-Cloud Secure Infrastructure Pipeline with Terraform & GitHub Actions

Modern enterprises demand more than just automated infrastructure—they demand **secure** infrastructure. This project was created to demonstrate my ability to design, implement, and automate a real-world DevSecOps pipeline that not only provisions cloud infrastructure but enforces security best practices **at every stage of deployment**.

Hiring managers often ask, "Can this engineer build scalable, compliant, and secure infrastructure from scratch?" This project answers that question with a resounding **yes**.

---

## 🌟 Executive Summary

- **Project Title**: Multi-Cloud Secure IaC Pipeline
- **Cloud Provider**: AWS (Azure coming soon)
- **Tools Used**: Terraform, GitHub Actions, Checkov, Snyk IaC, tfsec, AWS S3
- **Security First**: Security tools run before any infrastructure is deployed
- **CI/CD**: Fully automated deployment using GitHub Actions
- **Outcome**: Secure-by-default AWS infrastructure with continuous security validation

---

## 📁 The Problem

Traditionally, infrastructure provisioning is focused on uptime and scalability—security is often bolted on after. This creates risk. Misconfigured security groups, lack of VPC flow logs, open ports, and overly permissive IAM policies are all common issues.

This pipeline was built to **prevent those issues from ever reaching production**.

---

## ⚙️ Solution Architecture

Every time a change is pushed to the main branch:

1. **Security Scanning (Pre-Deployment)**
   - ✍️ **Checkov** runs static code analysis on Terraform files
   - 🧠 **Snyk IaC** performs deep configuration security scans
   - ⚖️ **tfsec** enforces security compliance policies (e.g., encryption, tagging)

2. **Terraform Provisioning**
   - `terraform init`, `plan`, and `apply` run inside GitHub Actions
   - AWS credentials and trusted IPs are pulled securely from GitHub Secrets

3. **Security Reports Saved to S3**
   - All SARIF and JSON reports are uploaded to a secure S3 bucket for compliance traceability

---

## 🎓 Tools Breakdown & Purpose

### ✅ Terraform
- Manages infrastructure as code
- Modular and version-controlled
- Deploys VPC, subnets, route tables, security groups, IAM roles, and VPC flow logs

### ✅ GitHub Actions
- Automates the CI/CD lifecycle
- Ensures consistency, reliability, and zero local dependencies
- Enforces pre-deployment security gates

### ✅ Checkov
- Detects Terraform misconfigurations
- Enforces best practices like:
  - VPC flow logs enabled
  - Security groups not open to the world
  - IAM policies scoped appropriately

### ✅ Snyk IaC
- Performs in-depth configuration analysis
- Flags dangerous patterns like:
  - Unrestricted SSH
  - Lack of encryption on data at rest
  - IAM roles with wildcard permissions
- Outputs results in SARIF and JSON

### ✅ tfsec
- Policy-as-code scanning with granular controls
- Custom policies include:
  - Required tag enforcement
  - Mandatory log retention periods
  - No plaintext secrets in code

### ✅ AWS S3
- Stores security scan reports securely
- Ensures traceability and historical audit readiness
- Bucket access is locked down using least privilege IAM roles

---

## 🔬 Real Results from Security Scans

Here’s an example finding from Snyk IaC:

```json
{
  "ruleId": "SNYK-CC-TF-1",
  "message": {
    "text": "Security group allows ingress from 0.0.0.0/0 on port 22 (SSH)"
  },
  "severity": "high",
  "location": {
    "path": "main.tf",
    "line": 14
  }
}
```

> ⚠️ This issue was immediately flagged, and the security group was locked down to `trusted_ip/32`, pulled securely from GitHub Secrets.

---

## 💡 Why This Project Matters

This project demonstrates:

- ✅ **End-to-end CI/CD security automation**
- ✅ **DevSecOps mindset from day one**
- ✅ **Real remediation of real misconfigurations**
- ✅ **No reliance on manual testing or local tools**
- ✅ **Audit-ready reports stored in cloud storage (S3)**

Security is **not an afterthought** in this pipeline. It is baked into every step.

If you're hiring for a DevSecOps or Cloud Security role, this is the type of thinking, automation, and execution that will reduce your risk exposure and increase engineering velocity.

---

## 🚀 What's Next

- ✨ Add Azure module to demonstrate true multi-cloud capability
- ✍️ Add approval workflow for `terraform apply` using GitHub environments
- ⚖️ Integrate OPA/Rego policies for governance
- 📊 Export reports to Security Hub / OpenSearch for visibility

---

## 📄 GitHub Repo

🔗 [View the Full Source Code Here](https://github.com/ginosettecasi/multi-cloud-secure-infra-pipeline)

---

**Written by Gino A. Settecasi** — Senior Security and Compliance Engineer passionate about automation, cloud security, and reducing risk through code.

