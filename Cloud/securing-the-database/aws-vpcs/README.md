# AWS Virtual Private Clouds (VPCs)

## Table of Contents
- [AWS Virtual Private Clouds (VPCs)](#aws-virtual-private-clouds-vpcs)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [1. Understanding AWS VPCs](#1-understanding-aws-vpcs)
    - [What is a VPC?](#what-is-a-vpc)
    - [Default VPC vs Custom VPC](#default-vpc-vs-custom-vpc)
    - [Key Components of a VPC](#key-components-of-a-vpc)
    - [Why Use a Custom VPC?](#why-use-a-custom-vpc)
  - [2. Steps to Create a Custom VPC](#2-steps-to-create-a-custom-vpc)
    - [Step 1 – Create the VPC](#step-1--create-the-vpc)
    - [Step 2 – Create Subnets](#step-2--create-subnets)
    - [Step 3 – Create Internet Gateway](#step-3--create-internet-gateway)
    - [Step 4 – Configure Route Tables](#step-4--configure-route-tables)
    - [Step 5 – Check VPC and Resource Map](#step-5--check-vpc-and-resource-map)
    - [Step 6 – Create Database Instance](#step-6--create-database-instance)
    - [Step 7 – Create Application Instance](#step-7--create-application-instance)
  - [Key Takeaways](#key-takeaways)
  - [Why \& Benefits of Virtual Private Clouds (VPCs)](#why--benefits-of-virtual-private-clouds-vpcs)
    - [Why We Do It](#why-we-do-it)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)

## Overview
This README explains the purpose of AWS Virtual Private Clouds (VPCs), key concepts, and the process of creating a custom VPC for a two-tier app deployment.  

---

## 1. Understanding AWS VPCs

### What is a VPC?
A **Virtual Private Cloud (VPC)** is an isolated virtual network dedicated to your AWS account.  
With it, you can control:  
- IP address ranges  
- Subnets  
- Route tables  
- Network gateways  
- Security rules (via Security Groups and Network ACLs)  

Think of it as your own apartment, where you don’t need to share your space with housemates!

![alt text](<../../images/Intro to AWC’s VPCs.png>)

### Default VPC vs Custom VPC
- **Default VPC**:  
  - Created automatically in every region.  
  - Includes a default subnet in each AZ.  
  - Internet access enabled.  
  - Security rules are more permissive (not best practice).  

- **Custom VPC**:  
  - Created by user for greater control.  
  - Choose CIDR block, number of subnets.  
  - Apply stricter security and routing.  
  - Preferred for production environments.  

### Key Components of a VPC
- **CIDR Block**: Defines IP address range (e.g., `10.0.0.0/16`).  
- **Subnets**:  
  - Public (internet-facing) vs private (internal).  
  - Tied to Availability Zones for resilience.  
- **Route Tables**:  
  - Default local route allows communication inside VPC.  
  - Custom routes send traffic to IGWs/NATs.  
- **Internet Gateway (IGW)**: Enables inbound/outbound internet connectivity.  
- **NAT Gateway**: Lets private subnets access internet without being exposed.  
- **Security Groups (SGs)**: Instance-level firewall rules (stateful).  
- **Network ACLs (NACLs)**: Subnet-level firewall rules (stateless).  
- **Availability Zones (AZs)**: Provide resilience across regions.  

### Why Use a Custom VPC?
- Greater control over network design.  
- Improved security (least privilege).  
- Better scalability for growth.  
- Regulatory compliance.  

---

## 2. Steps to Create a Custom VPC
<br>

![alt text](<../../images/Plan Custom VPC for 2-tier deployment of sparta test app.png>)

<br>

### Step 1 – Create the VPC
- VPC Only → Name: `tech511-lauren-2tier-first-vpc`.  
- IPv4 CIDR: `10.0.0.0/16`.  

### Step 2 – Create Subnets
- **Public Subnet**:  
  - Name: `tech511-lauren-public-subnet`.  
  - AZ: `eu-west-1a`.  
  - CIDR: `10.0.2.0/24`.  

- **Private Subnet**:  
  - Name: `tech511-lauren-private-subnet`.  
  - AZ: `eu-west-1b`.  
  - CIDR: `10.0.3.0/24`.  

### Step 3 – Create Internet Gateway
- Name: `tech511-lauren-2tier-first-vpc-ig`.  
- Attach to VPC.  

### Step 4 – Configure Route Tables
- Default route table = private traffic.  
- Create public route table:  
  - Name: `tech511-lauren-2tier-first-vpc-public-rt`.  
  - Associate public subnet.  
- Add route:  
  - Destination: `0.0.0.0/0`.  
  - Target: Internet Gateway.  

### Step 5 – Check VPC and Resource Map
- View resource map in VPC console to confirm components.  

### Step 6 – Create Database Instance
- Use MongoDB AMI.  
- Place in custom VPC, private subnet.  
- Disable public IP.  
- Create new SG: allow TCP port `27017` (temporary → later restrict).  

### Step 7 – Create Application Instance
- Launch from AMI.  
- Place in custom VPC, public subnet.  
- Enable public IP.  
- Create SG: allow HTTP + SSH.  
- Update user data: set `DB_HOST` to DB instance’s private IP.  

---

## Key Takeaways
- VPCs give control of networking in AWS.  
- Default VPCs are convenient but insecure for production.  
- Custom VPCs enable multi-tier secure architectures.  
- Proper subnet design separates public and private resources.  

---

## Why & Benefits of Virtual Private Clouds (VPCs)

### Why We Do It
Custom VPCs provide control and security for cloud networking. Instead of relying on permissive defaults, we design resilient, compliant environments for apps and databases.  

### Benefits for Me
- Learned fundamentals of networking in the cloud.  
- Gained hands-on practice with subnets, routes, gateways, and SGs.  
- Understood difference between public/private subnets.  
- Improved troubleshooting skills around connectivity and permissions.  
- Built confidence to design multi-tier app architectures.  

### Benefits for the Home Office
- **Security:** Keeps sensitive systems (databases) private.  
- **Compliance:** Aligns with strict regulations on data.  
- **Scalability:** Supports future growth and new services.  
- **Reliability:** Multi-AZ design improves availability.  
- **Cost efficiency:** Smart routing/NAT use balances performance with cost.  
- **Future-proof:** Foundation for integration with advanced AWS services.  
