# Terraform Installation, Files, Backends & Git Ignore

- [Terraform Installation, Files, Backends \& Git Ignore](#terraform-installation-files-backends--git-ignore)
  - [Overview](#overview)
  - [1. Verifying Terraform \& Running It Correctly](#1-verifying-terraform--running-it-correctly)
  - [2. Project Structure \& Important Files](#2-project-structure--important-files)
    - [Core Code Files](#core-code-files)
    - [Hidden/Generated Files](#hiddengenerated-files)
  - [3. Providers, Backends \& Locking](#3-providers-backends--locking)
    - [Providers](#providers)
    - [Backends (State Storage)](#backends-state-storage)
    - [Locking Provider Versions](#locking-provider-versions)
  - [4. Terraform Commands](#4-terraform-commands)
  - [5. How Terraform Talks to Cloud Providers](#5-how-terraform-talks-to-cloud-providers)
  - [6. Configuration Drift (What It Is \& How To Fix It)](#6-configuration-drift-what-it-is--how-to-fix-it)
  - [7. Git Ignore for Terraform](#7-git-ignore-for-terraform)
  - [8. Step-by-Step Process (What I Did)](#8-step-by-step-process-what-i-did)
    - [Step 1: Check Terraform \& Folder](#step-1-check-terraform--folder)
    - [Step 2: Initialise \& Observe Generated Files](#step-2-initialise--observe-generated-files)
    - [Step 3: Add a Terraform .gitignore](#step-3-add-a-terraform-gitignore)
    - [Step 4: Commit, Rename Branch, Push](#step-4-commit-rename-branch-push)
  - [Key Takeaways](#key-takeaways)
  - [Why \& Benefits of Today’s Terraform Topics](#why--benefits-of-todays-terraform-topics)
    - [Why We Do It](#why-we-do-it)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)


## Overview
This README explains:
- How to **confirm Terraform is installed** and runnable from any terminal.
- The **project structure**, including key Terraform-created files and what they do.
- **State files**: what they are, why they’re sensitive, and how to store/share them safely.
- **Backends and providers**, and **locking provider versions** for team consistency.
- The core **Terraform commands** and what they do.
- **Configuration drift** and which tools fix infra vs software drift.
- A safe **.gitignore** for Terraform repos.
- A **step-by-step** recap of today’s workflow.

---

## 1. Verifying Terraform & Running It Correctly
- Check install/version:

  `terraform -version


* Terraform must be on the **system PATH** to work from **any terminal**.
* Run Terraform commands **from your project folder** (where your `.tf` files live).

---

## 2. Project Structure & Important Files

### Core Code Files

* **`main.tf`** — main Terraform configuration (resources, providers, etc.).
* **`variables.tf`** — variable declarations; keep sensitive values out of flat code.
* Optional: `outputs.tf`, `providers.tf`, `locals.tf` for clearer organisation.

### Hidden/Generated Files

* **`.terraform/`** — hidden folder; caches **provider plugins** and backend metadata.
* **`.terraform.lock.hcl`** — pins **provider versions**; commit this to keep teams in sync.
* **`terraform.tfstate`** — **current state** of infra; *sensitive*, **never commit**.
* **`terraform.tfstate.backup`** — backup of state before changes; *sensitive*, **never commit**.

> Treat state files as secrets: they can include credentials and detailed resource metadata.

---

## 3. Providers, Backends & Locking

### Providers

* Providers define how Terraform interacts with a platform (AWS, Azure, GCP).
* Downloaded into `.terraform/` during `terraform init`.

### Backends (State Storage)

* **Where your state lives** (local by default).
* For teams, use a **remote backend with locking**:

  * **AWS**: S3 for state + **DynamoDB** table for **state locking**.
  * **Azure**: **Blob Storage** (includes locking).
  * **Terraform Cloud**: managed state + locking, easy team access.

### Locking Provider Versions

* **`.terraform.lock.hcl`** ensures everyone uses the **same provider versions**.
* Commit it to the repo to prevent unexpected upgrade breakages.

---

## 4. Terraform Commands

* **`terraform init`**

  * Sets up the **backend** (local/remote).
  * Downloads **provider plugins**.
  * Creates **`.terraform.lock.hcl`** if missing.
* **`terraform plan`**

  * **Non-destructive** preview of proposed changes.
* **`terraform apply`**

  * **Destructive** (performs creates/updates/destroys).
* **`terraform destroy`**

  * **Destructive** removal of resources.

---

## 5. How Terraform Talks to Cloud Providers

* Providers call the platform **APIs** under the hood:

  * **AWS**: multiple service-specific APIs.
  * **Azure**: unified **ARM** (Azure Resource Manager) API.
  * **GCP**: multiple service APIs.
* Cloud consoles also call these APIs; Terraform does it declaratively via code.

---

## 6. Configuration Drift (What It Is & How To Fix It)

* **Definition**: Environments that should be identical **diverge over time** due to manual changes.
* **Examples**:

  * SSH into one VM and install a package / edit a config only there.
  * Renaming an instance directly in the console (outside Terraform).
* **Fixing**:

  * **Infrastructure drift** → run **Terraform** to reconcile infra to match code (detects/renames/updates).
  * **Software/config drift** → use **configuration management** (e.g., **Ansible**) to enforce packages/files/versions.

---

## 7. Git Ignore for Terraform

Never commit state or local caches. Typical entries:

```
.terraform/
terraform.tfstate
terraform.tfstate.backup
*.tfvars
*.tfvars.json
crash.log
override.tf
override.tf.json
*_override.tf
*_override.tf.json
.terraformrc
terraform.rc
```

* New repo: choose the **Terraform** template in GitHub’s repo wizard.
* Existing repo: paste the template into a new `.gitignore` at the repo root (verify hidden files with `ls -la`).

---

## 8. Step-by-Step Process (What I Did)

### Step 1: Check Terraform & Folder

* Verified installation:

  ```bash
  terraform -version
  ```
* Ensured I’m inside the **Terraform project folder** (where `main.tf` lives).

**Why:** Validates environment and avoids running commands in the wrong directory.

### Step 2: Initialise & Observe Generated Files

* Ran:

  ```bash
  terraform init
  ```
* Observed creation/usage of:

  * `.terraform/` (providers + backend metadata)
  * `.terraform.lock.hcl` (provider version pinning)

**Why:** Prepares providers/backend and prevents silent provider upgrades.

### Step 3: Add a Terraform .gitignore

* For existing repos, added Terraform template to `.gitignore`.
* Confirmed hidden files with:

  ```bash
  ls -la
  ```

**Why:** Prevents accidental leakage of **state** and local cache files.

### Step 4: Commit, Rename Branch, Push

* Commit:

  ```bash
  git add .
  git commit -m "Terraform: init, providers, backend notes, .gitignore"
  ```
* If needed, rename branch:

  ```bash
  git branch -M main
  ```
* Push:

  ```bash
  git push origin main
  ```

**Why:** Clean repo hygiene, correct default branch, and safe sharing.

---

## Key Takeaways

* `terraform init` prepares **backend + providers** and writes the **lock file**.
* **State files are sensitive** → never commit; use **remote state with locking** for teams.
* Commit **`.terraform.lock.hcl`** to keep **provider versions** consistent.
* Use **Terraform** for **infrastructure drift**; use **Ansible** (or similar) for **software drift**.
* A proper **`.gitignore`** is essential to protect credentials and local state.

---

## Why & Benefits of Today’s Terraform Topics

### Why We Do It

* To **codify infrastructure** so it’s **repeatable, auditable, and reliable**.
* To **prevent breakage** from provider upgrades (lock file).
* To **protect secrets** and avoid accidental leaks (ignore state/local files).
* To enable **safe team collaboration** via **remote state with locking**.

### Benefits for Me

* I can **recreate environments** confidently and fix drift quickly.
* I know **what to commit** vs **what to protect**.
* I can work in a **team** with **shared state** and **consistent providers**.
* Builds strong habits around **Git hygiene**, **security**, and **cloud APIs**.

### Benefits for the Home Office

* **Security & compliance**: stops secret leakage; controlled state with locking.
* **Reliability**: drift detection/reconciliation reduces outages.
* **Team scalability**: clear, versioned infra code supports collaborative delivery.
* **Auditability**: plan/apply flows make changes reviewable and traceable.

---
