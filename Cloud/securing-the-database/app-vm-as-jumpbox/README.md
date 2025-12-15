- [Using Our App VM as a Jumpbox for our DB VM](#using-our-app-vm-as-a-jumpbox-for-our-db-vm)
  - [What is a Jumpbox?](#what-is-a-jumpbox)
  - [Why Use a Jumpbox for our DB VM?](#why-use-a-jumpbox-for-our-db-vm)
  - [Steps Taken to Complete the Task](#steps-taken-to-complete-the-task)
    - [Create a VPC](#create-a-vpc)
    - [Create Database Instance](#create-database-instance)
    - [Create App Instance](#create-app-instance)


# Using Our App VM as a Jumpbox for our DB VM

## What is a Jumpbox?

## Why Use a Jumpbox for our DB VM?

## Steps Taken to Complete the Task

### Create a VPC
  *Brief summary; if more info needed, refer to aws-vpc's [README.md](../s3/README.md) for more detail*
    1. Create new VPC
    2. Create subnets - public and private
    3. Create Internet Gateway
    4. Configure Route Tables
    5. Check VPC and Resource Map

### Create Database Instance
  1. Use AMI with MongoDB preinstalled
  2. Follow instructions from before, EXCEPT - change source type to custom, add public subnet's CIDR
  3. Launch

### Create App Instance
1. Use AMI with user data pre-installed
2. Follow instructions from before, ensuring accessible from the internet
3. Remember to update user data with the data to run the app, including the PRIVATE ip address from the DB VM.
4. Launch 