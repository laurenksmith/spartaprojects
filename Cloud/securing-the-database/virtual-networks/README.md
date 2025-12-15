# Introduction to Virtual Networking

## Table of Contents
- [Introduction to Virtual Networking](#introduction-to-virtual-networking)
  - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [1. What is a Virtual Network?](#1-what-is-a-virtual-network)
  - [2. Terminology Used with Virtual Networks](#2-terminology-used-with-virtual-networks)
  - [3. Understanding IPv4 Addresses and CIDR Blocks](#3-understanding-ipv4-addresses-and-cidr-blocks)
  - [](#)
  - [4. AWS Defaults](#4-aws-defaults)
  - [5. Why Create a Custom Virtual Network?](#5-why-create-a-custom-virtual-network)
  - [6. Subnets in More Detail](#6-subnets-in-more-detail)
  - [7. Routing and Traffic Flow](#7-routing-and-traffic-flow)
  - [8. Security Layers](#8-security-layers)
  - [9. Peering and Connectivity](#9-peering-and-connectivity)
  - [Key Takeaways](#key-takeaways)
  - [Why \& Benefits of Virtual Networking](#why--benefits-of-virtual-networking)
    - [Why We Do It](#why-we-do-it)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)

## Overview
This README introduces the concept of virtual networking in the cloud, explaining key terms, IP addressing, AWS defaults, and why organisations create custom networks.  

---

## 1. What is a Virtual Network?
- A network connects 2+ devices together.  
- A **virtual network** is a way for devices in the cloud to talk to each other.  
- Steps:  
  - Define range of private IPs.  
  - Split into subnets.  
  - Control traffic flow with firewall rules and routing.  

Analogy: A VN is like an apartment, and subnets are the rooms inside.  

---

## 2. Terminology Used with Virtual Networks
- **VPC/VNet**: the overall virtual network.  
  - AWS: VPC.  
  - Azure: VNet.  
  - GCP: VPC.  
- **Subnet**: a section of the network (rooms within the house).  
- **Firewall / SG / NSG / NACL**: rules to allow/deny traffic.  
  - AWS: SGs (instance-level), NACLs (subnet-level).  
- **Route Table**: defines traffic flow.  
- **Peering**: connects two networks to communicate privately.  

---

## 3. Understanding IPv4 Addresses and CIDR Blocks
- IPv4 = 32-bit, written as four octets (e.g. `192.168.1.10`).  
- Private ranges:  
  - `10.0.0.0 – 10.255.255.255`  
  - `172.16.0.0 – 172.31.255.255`  
  - `192.168.0.0 – 192.168.255.255`  
- CIDR (Classless Inter-Domain Routing):  
  - Tells network vs host bits.  
  - Example: `10.0.0.0/16` → `/16` = first 16 bits for network, 16 for hosts.  

![alt text](<../../images/How an IPv4 Address Works.png>)
---

## 4. AWS Defaults
- AWS provides a **default VPC** in every region.  
- Default VPC has:  
  - A subnet in each AZ.  
  - Internet connectivity.  
  - Permissive default security rules.  

⚠️ Not best practice for production — companies usually build custom VPCs.  

---

## 5. Why Create a Custom Virtual Network?
- **Control:** custom IP ranges, subnet sizes, layout.  
- **Security:** stricter rules than defaults.  
- **Scalability:** design to grow with applications.  
- **Compliance:** meet organisational/regulatory needs.  

---

## 6. Subnets in More Detail
- Subnets = smaller parts of a network.  
- Design pattern:  
  - **Public Subnet:** internet-facing (load balancers, bastion hosts).  
  - **Private Subnet:** internal-only (databases, app servers).  
- Subnets are tied to AZs for resilience.  
- Each subnet can have its own route table/rules.  

---

## 7. Routing and Traffic Flow
- **Route tables** control how traffic moves.  
- Key routes:  
  - Local route: subnets talk by default.  
  - IGW: internet access.  
  - NAT Gateway: outbound internet for private subnets.  

Without correct routes, resources can’t communicate.  

---

## 8. Security Layers
- **Security Groups (SGs):**  
  - Instance-level.  
  - Stateful (return traffic auto-allowed).  

- **Network ACLs (NACLs):**  
  - Subnet-level.  
  - Stateless (rules apply both ways).  

Best practice: SGs for everyday, NACLs for extra protection.  

---

## 9. Peering and Connectivity
- **VPC Peering** connects 2+ VPCs for private communication.  
- Traffic stays on AWS backbone (not the public internet).  
- Example: shared services VPC connected to multiple app VPCs.  

---

## Key Takeaways
- Virtual networks = cloud equivalent of data centres.  
- Subnets, routing, and firewalls define traffic flow.  
- AWS provides defaults, but production usually = custom VPCs.  
- Peering enables connectivity between networks.  

---

## Why & Benefits of Virtual Networking

### Why We Do It
Virtual networks provide the foundation for communication and security in the cloud. Without them, resources would be isolated and unmanageable.  

### Benefits for Me
- Learned core networking concepts used across AWS, Azure, GCP.  
- Gained confidence in CIDR and IP addressing.  
- Built knowledge of firewalls (SGs vs NACLs).  
- Practised designing public/private subnet layouts.  
- Strengthened problem-solving around traffic flow.  

### Benefits for the Home Office
- **Security:** isolates sensitive systems (e.g. immigration DBs).  
- **Compliance:** ensures data flows match regulatory standards.  
- **Scalability:** custom networks support growing workloads.  
- **Reliability:** multi-AZ subnet design boosts resilience.  
- **Efficiency:** peering/private routing keeps traffic secure and cost-effective.  
