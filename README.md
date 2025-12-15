# Sparta Projects

[![Python](https://img.shields.io/badge/Python-learning-3776AB)](python/)
[![Cloud (AWS)](https://img.shields.io/badge/Cloud-AWS-232F3E)](Cloud/)
[![IaC](https://img.shields.io/badge/IaC-Terraform%20%2B%20Ansible-5C4EE5)](IaC/)
[![CI/CD](https://img.shields.io/badge/CI%2FCD-Jenkins-D24939)](CICD/)

A curated collection of my learning from the **Sparta Global Academy** — culminating in my role as a **Level 2 Support Engineer**.  
It covers **Python fundamentals**, **AWS/cloud**, **Infrastructure as Code** (Terraform + Ansible), and a **Jenkins-driven CI/CD pipeline**.

> Focus: reliable, supportable systems with clear docs, playbooks, and reproducible pipelines.

## Repo Structure

spartaprojects/
├─ python/                     # Scripts, exercises, OOP, small tasks
├─ Cloud/                      # AWS: VPCs, networks, S3, monitoring, autoscaling
├─ IaC/                        # Terraform + Ansible examples, two-tier app infra/config
├─ CICD/                       # Jenkins notes, first-time setup, pipeline diagram
└─ README.md                   # ← you are here 😄


## Top 4 entry points

- **Two-Tier App (Terraform)** →   [README.md](IaC/2-tier-app/README.md)
- **Ansible Playbooks (app + db)** → [Playbooks](IaC/terraform/ansible-learning/playbooks/)   
- **AWS VPCs (networking notes)** → [`Cloud/Securing the Database/aws-vpcs/README.md`](Cloud/Securing%20the%20Database/aws-vpcs/README.md)  
- **Python tasks & mini-projects** → [`python/`](python/)


## Highlights by Area

### Python
Foundations through to small projects: modules, OOP, unit tests, JSON/YAML translations.
- Folder: [`python/`](python/)
- Examples:
  - Code-along snippets → [`python/codealong/`](python/codealong/)
  - OOP tasks → [`python/oop/`](python/oop/) and [`python/my_own_oop/`](python/my_own_oop/)
  - Collections/control-flow tasks → [`python/python_tasks_and_projects/`](python/python_tasks_and_projects/)
  - JSON↔YAML converter → [`python/translation/json2yaml.py`](python/translation/json2yaml.py) with sample [`original.json`](python/translation/original.json) and [`translation.yaml`](python/translation/translation.yaml)
  - Variables mini-guide → [`python/variables/README.md`](python/variables/README.md)

### Cloud (AWS)
EC2, networking/VPCs, S3 basics, monitoring/alerts, autoscaling patterns.
- Folder: [`Cloud/`](Cloud/)
- Deep links:
  - VPCs (networking primer) → [`Cloud/Securing the Database/aws-vpcs/README.md`](Cloud/Securing%20the%20Database/aws-vpcs/README.md)
  - Virtual networks overview → [`Cloud/Securing the Database/virtual-networks/README.md`](Cloud/Securing%20the%20Database/virtual-networks/README.md)
  - App VM as jumpbox (notes) → [`Cloud/Securing the Database/app-vm-as-jumpbox/`](Cloud/Securing%20the%20Database/app-vm-as-jumpbox/)
  - S3 + boto3 task → [`Cloud/s3/boto3-task.md`](Cloud/s3/boto3-task.md)
  - Monitoring & alerts task → [`Cloud/monitoring-and-alerts/alerts-task.md`](Cloud/monitoring-and-alerts/alerts-task.md)
  - Auto Scaling Groups overview → [`Cloud/auto-scaling-groups/README.md`](Cloud/auto-scaling-groups/README.md)

### Infrastructure as Code (Terraform & Ansible)
From single VM security-group tests to a two-tier app, plus Ansible inventories and playbooks.
- Folder: [`IaC/`](IaC/)

**Terraform**
- Two-Tier App (app + db + userdata template)  
  - Guide → [`IaC/2-tier-app/README.md`](IaC/2-tier-app/README.md)  
  - Root module → [`IaC/2-tier-app/main.tf`](IaC/2-tier-app/main.tf), [`database.tf`](IaC/2-tier-app/database.tf), [`variable.tf`](IaC/2-tier-app/variable.tf)  
  - Userdata template → [`IaC/2-tier-app/run-app.sh.tftpl`](IaC/2-tier-app/run-app.sh.tftpl)
- Create-a-test VM + SG (minimal example)  
  - → [`IaC/create-test-vm-sg/README.md`](IaC/create-test-vm-sg/README.md), [`main.tf`](IaC/create-test-vm-sg/main.tf), [`terraform.tf`](IaC/create-test-vm-sg/terraform.tf), [`variable.tf`](IaC/create-test-vm-sg/variable.tf)
- Intro & setup notes  
  - Terraform install & first steps → [`IaC/intro-to-tf/terraform-installation.md`](IaC/intro-to-tf/terraform-installation.md)  
  - IaC concepts intro → [`IaC/intro-to-tf/intro-to-iac.md`](IaC/intro-to-tf/intro-to-iac.md)  
  - AWS env vars → [`IaC/intro-to-tf/aws-env-variables.md`](IaC/intro-to-tf/aws-env-variables.md)  
  - Using `.gitignore` with IaC → [`IaC/intro-to-tf/using-.gitignore.md`](IaC/intro-to-tf/using-.gitignore.md)  
  - Source of truth / drift notes → [`IaC/configuration-drift-source-of-truth.md`](IaC/configuration-drift-source-of-truth.md)

**Ansible**
- Controller/App/DB structure → [`IaC/terraform/ansible/README.md`](IaC/terraform/ansible/README.md)  
  - Controller → [`IaC/terraform/ansible/controller/`](IaC/terraform/ansible/controller/)  
  - App node → [`IaC/terraform/ansible/app-node/`](IaC/terraform/ansible/app-node/)  
  - DB node → [`IaC/terraform/ansible/db-node/`](IaC/terraform/ansible/db-node/)
- Learning playbooks (idempotent tasks & verification) → [`IaC/terraform/ansible-learning/playbooks/`](IaC/terraform/ansible-learning/playbooks/)  
  - App provisioning variants:  
    - [`prov-app-all.yml`](IaC/terraform/ansible-learning/playbooks/prov-app-all.yml)  
    - [`prov-app.yml`](IaC/terraform/ansible-learning/playbooks/prov-app.yml)  
    - [`prov_app_with_pm2.yml`](IaC/terraform/ansible-learning/playbooks/prov_app_with_pm2.yml)  
    - [`prov_app_with_pm2_copy.yml`](IaC/terraform/ansible-learning/playbooks/prov_app_with_pm2_copy.yml)  
    - [`prov_app_with_npm_start.yml`](IaC/terraform/ansible-learning/playbooks/prov_app_with_npm_start.yml)
  - DB provisioning:  
    - [`install_mongodb.yml`](IaC/terraform/ansible-learning/playbooks/install_mongodb.yml)  
    - [`prov-db.yml`](IaC/terraform/ansible-learning/playbooks/prov-db.yml)
  - Nginx:  
    - [`install_nginx.yml`](IaC/terraform/ansible-learning/playbooks/install_nginx.yml)
  - Utilities:  
    - [`master-playbook.yml`](IaC/terraform/ansible-learning/playbooks/master-playbook.yml)  
    - [`print-facts.yml`](IaC/terraform/ansible-learning/playbooks/print-facts.yml)

### CI/CD (Jenkins)
First-time setup notes, plus a visual of how the pipeline stages connect.
- Folder: [`CICD/`](CICD/)
- Quick starts:
  - How our Jenkins CI/CD works (diagram PNG) → [`CICD/images/How Our CICD Pipeline on Jenkins Works.png`](CICD/images/How%20Our%20CICD%20Pipeline%20on%20Jenkins%20Works.png)
  - Folder overview → [`CICD/README.md`](CICD/README.md)

## End-to-End (Two-Tier App + CI/CD)

1. **Code** → Commit to GitHub (`dev`).  
2. **CI** → Jenkins runs tests on push.  
3. **Promote** → Merge `dev → main` on green.  
4. **Infra** → Terraform builds/updates EC2 + security groups.  
5. **Config** → Ansible provisions **app** and **MongoDB** (idempotent).  
6. **Deploy** → Jenkins ships artefacts to EC2 (SCP/rsync) and restarts service.  
7. **Verify** → Front page + `/posts` smoke tests.

Diagrams & screenshots live under:
- CI/CD visuals → [`CICD/images/`](CICD/images/)
- Any VPC/network sketches (if added) → `IaC/` or `Cloud/` subfolders

## How to Use This Repo

- Each folder includes notes/READMEs with prerequisites and commands.  
- Linux-first (Bash/WSL). For AWS/Terraform/Ansible you’ll need:
  - AWS account + key pair
  - `awscli`, `terraform`, `ansible`, `ssh`
  - AWS credentials via profiles or env vars

## About Me

I’m **Lauren**, now a **Level 2 Support Engineer** (ex-primary teacher). I’ve been **investing in myself**, and I’m now looking to **add value and use all the skills I’ve learnt to date** in real-world teams.

- Focus areas: supportability, CI/CD, IaC, clear runbooks  
- Connect:
  - LinkedIn: [Lauren Copas](www.linkedin.com/in/laurenkimsmith)
  - GitHub: [laurenksmith](https://github.com/laurenksmith)

