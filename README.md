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

| Tool | Purpose |
|------|---------|
| Terraform | Provision secure AWS & Azure infrastructure |
| GitHub Actions | CI/CD automation |
| Checkov | IaC security linting |
| Snyk | Dependency scanning |
| AWS & Azure | Multi-cloud environments (Free Tier) |

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

