# Intro to IaC

- [Intro to IaC](#intro-to-iac)
  - [What Problem Needs Solving?](#what-problem-needs-solving)
  - [What Have We Automated So Far?](#what-have-we-automated-so-far)
  - [Solving Problem](#solving-problem)
  - [What is IaC?](#what-is-iac)
  - [Benefits of IaC](#benefits-of-iac)
  - [When/Where to Use IaC](#whenwhere-to-use-iac)
  - [Tools Available for IaC / Types of IaC Tools](#tools-available-for-iac--types-of-iac-tools)

## What Problem Needs Solving?

* We are still manually "provisioning" the servers
  * What do we mean by "provisioning"? <br>
  *The process of setting up and configuring servers*

<br>

## What Have We Automated So Far?
* VMs
  * Creation of VMs? No
  * Creation of the infrastructure they live in (e.g. VNet)? No
  * Setup & configuration of the software on the VMs?  Yes, how?
    * Bash scripts
    * User data
    * AMIs

## Solving Problem

Infrastructure as Code (IaC) can do the provisioning of:
* the infrastructure itself (servers)
* configuring the servers i.e. installing software and configuring settings

## What is IaC?

* A way to manage and provision computers through a machine-readable definition of the infrastructure
* ** **Usually** ** you codify WHAT you want (declarative: you define the desired state/outcomes), not HOW to do it (imperative)

<br>

## Benefits of IaC

* speed + simplicity
  * reduce the time to deploy your infrastructure
  * you simply describe the end state, and the tool works out the rest
* consistency + accuracy
  * avoid human trying to create/maintain the same infrastructure
* version control
  * keep track of version of infrastructure
* scalability
  * very easy to scale/duplicate the infrastructure, including for different environments

<br>

## When/Where to Use IaC

* Use good judgement - will automating your infrastructure be worth the investment in time?

## Tools Available for IaC / Types of IaC Tools

* Two types:
  * Configuration management tools - best for installing/configuring software
    1. Chef
    2. Puppet
    3. Ansible
* Orchestration tools - best for managing infrastructure, e.g. VMs, security groups, route tables etc
    1. Terraform
    2. CloudFormation (AWS)
    3. ARM/Bicep templates (Azure)
    4. Ansible (can do this, but best for configuration management)