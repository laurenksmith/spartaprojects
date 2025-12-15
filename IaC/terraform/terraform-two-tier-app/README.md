# Creating My 2-Tier App on AWS Using Terraform

[Creating My 2-Tier App on AWS Using Terraform](#creating-my-2-tier-app-on-aws-using-terraform)
- [Creating My 2-Tier App on AWS Using Terraform](#creating-my-2-tier-app-on-aws-using-terraform)
  - [Overview](#overview)
  - [Problem We’re Solving](#problem-were-solving)
  - [1. Part One: App VM Deployment](#1-part-one-app-vm-deployment)
  - [**Why:** This set up the front-end tier and confirmed app availability.](#why-this-set-up-the-front-end-tier-and-confirmed-app-availability)
  - [2. Part Two: Database VM Deployment](#2-part-two-database-vm-deployment)
  - [**Why:** This separated database logic from the app, ensuring security and reliability.](#why-this-separated-database-logic-from-the-app-ensuring-security-and-reliability)
  - [3. Part Three: Custom VPC Deployment](#3-part-three-custom-vpc-deployment)
  - [Key Takeaways](#key-takeaways)
  - [Why \& Benefits of Two-Tier Deployment](#why--benefits-of-two-tier-deployment)
    - [Why We Do It](#why-we-do-it)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)
  - [Diagram](#diagram)

## Overview
This README explains:
- How I used **Terraform** to automate the creation of a two-tier architecture on AWS.  
- The **three parts** of the process: deploying the App VM, the Database VM, and then building it all into a custom VPC with subnets and routing.  
- Why this architecture matters, the problem it solves, and the benefits it brings.  
---

## Problem We’re Solving
Running a single VM with both the application and database tightly coupled creates issues:
- If the VM fails, both the app and DB go offline.  
- Harder to scale, since app and database have different requirements.  
- Security risk: database shouldn’t be publicly exposed.  
- Manual deployment is error-prone and time-consuming.  

A **two-tier deployment** separates the app from the database and ensures:
- The app can scale independently.  
- The database stays private and secure in its own subnet.  
- Infrastructure is reproducible and automated through Terraform.  
---

## 1. Part One: App VM Deployment
- Used Terraform to create a **security group** for the App VM (allowed required ports such as SSH and HTTP).  
- Created an **App VM** using my **custom App AMI**.  
- Included **user data script** (so the app starts automatically). 
  ![alt text](../images/image.png) 
- Added **key pair** through the variables file.  
- Verified: front page worked correctly at the public IP.  

**Why:** This set up the front-end tier and confirmed app availability.  
---

## 2. Part Two: Database VM Deployment
- Created a **Database VM** in Terraform using my **custom Database AMI**.  
- Made a **security group** allowing only the necessary connections (e.g., from the App VM).  
- Configured Terraform so the **App VM user data** referenced the Database VM’s **private IP** (auto-updated, since private IPs can change).  
- Verified: posts page now worked (app could connect to database).  

**Why:** This separated database logic from the app, ensuring security and reliability.  
---

## 3. Part Three: Custom VPC Deployment
- Created a **new custom VPC** in Terraform with two subnets:  
  - **Public Subnet:** hosted the App VM, with an Internet Gateway + Public Route Table.  
  - **Private Subnet:** hosted the Database VM, no Internet access (default route table only).  
- Attached Internet Gateway to the VPC for outbound/public access.  
- Ensured correct **routing tables** were applied (public subnet routed to IGW, private subnet stayed internal).  
- Updated **security groups** to allow secure linking between the App and DB.  

**Why:** This gave a secure, isolated network design with proper public/private separation.  

__*Website I used to support me*__
https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet

---

## Key Takeaways
- Terraform can automate **multi-tier architecture** deployments.  
- Using a **custom VPC** ensures proper isolation between public and private resources.  
- **User data scripts** + **variables** make instances self-configuring and repeatable.  
- Private IP referencing ensures database connections stay intact even if IPs change.  
- This setup mirrors real-world infrastructure design principles.  
---

## Why & Benefits of Two-Tier Deployment

### Why We Do It
- To separate concerns: app tier vs database tier.  
- To improve fault tolerance and scalability.  
- To secure sensitive data by keeping DB in a private subnet.  
- To make deployments reproducible and consistent using Infrastructure as Code.  

### Benefits for Me
- Stronger grasp of real-world cloud architectures.  
- Practice with Terraform’s modular, file-based approach.  
- Hands-on skills with networking: subnets, routing, IGWs, SGs.  
- Confidence in linking VMs securely via private IPs.  

### Benefits for the Home Office
- **Resilience:** apps and databases are separate, so failure is isolated.  
- **Security:** databases remain private, reducing attack surface.  
- **Scalability:** app tier can grow with demand without overloading DB.  
- **Automation:** reproducible builds reduce human error and speed up deployments.  
- **Best practices:** aligns with industry standards for secure government infrastructure.  

## Diagram
```mermaid
graph TD
  %% ============
  %% Top-down VPC
  %% ============
  Internet((Internet))
  IGW[(Internet Gateway)]

  subgraph VPC["Custom VPC 10.0.0.0/16"]
    direction TB

    subgraph Public["Public Subnet 10.0.1.0/24"]
      App[(EC2 App VM\nUbuntu 22.04)]
      SGApp[SG-App\nin:22 SSH from YourIP\nin:80 HTTP from 0.0.0.0/0\nout:all]
      RTpub[Public RT\n0.0.0.0/0 -> IGW]
      App --- SGApp
    end

    subgraph Private["Private Subnet 10.0.2.0/24"]
      DB[(EC2 DB VM\nMongoDB)]
      SGDB[SG-DB\nin:27017 from SG-App\nout:vpc-only]
      RTpriv[Private RT\nno 0.0.0.0/0]
      DB --- SGDB
    end
  end

  %% Traffic & routing
  Internet -->|HTTP:80/SSH:22| App
  App -->|MongoDB:27017\nprivate IP| DB
  RTpub --> IGW


  ```

