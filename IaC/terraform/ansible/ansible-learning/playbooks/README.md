# Ansible Ad Hoc Commands and Playbooks

- [Ansible Ad Hoc Commands and Playbooks](#ansible-ad-hoc-commands-and-playbooks)
  - [Overview](#overview)
  - [The Why](#the-why)
  - [Problem We’re Solving](#problem-were-solving)
  - [1) Preparing the Environment](#1-preparing-the-environment)
  - [2) Update the Inventory (Private IP)](#2-update-the-inventory-private-ip)
  - [3) Ad-Hoc Commands](#3-ad-hoc-commands)
    - [Example 1 — Check Linux Version](#example-1--check-linux-version)
    - [Example 2 — Run an Update (non-idempotent)](#example-2--run-an-update-non-idempotent)
  - [4) Using Idempotent Modules (Best Practice)](#4-using-idempotent-modules-best-practice)
  - [5) Creating Our First Playbook — Install Nginx](#5-creating-our-first-playbook--install-nginx)
  - [6) Creating a Playbook to Print Facts](#6-creating-a-playbook-to-print-facts)
  - [7) Expanding the Inventory — DB and Parent Groups](#7-expanding-the-inventory--db-and-parent-groups)
  - [8) Verify Inventory Structure](#8-verify-inventory-structure)
  - [9) The Reusable Recipe - How to Write Any Playbook](#9-the-reusable-recipe---how-to-write-any-playbook)
  - [Provision + Run the App (npm start)](#provision--run-the-app-npm-start)
  - [Provision + Run the App (PM2)](#provision--run-the-app-pm2)
  - [Verifying It Works](#verifying-it-works)
  - [Why \& Benefits](#why--benefits)
    - [Why We Do It](#why-we-do-it)
    - [Benefits for Me](#benefits-for-me)
    - [Benefits for the Home Office](#benefits-for-the-home-office)
  - [Troubleshooting Notes](#troubleshooting-notes)
  - [Websites Used / References](#websites-used--references)

## Overview
This note captures the **simple**, working approach I used:
- Ad-hoc commands for quick checks.
- Small, idempotent **playbooks** to install Nginx + Node.js.
- Two ways to run the Node app:
  - `npm start` (foreground command, run as my normal user)
  - `pm2` (process manager to keep it alive)

Everything here uses a single host group: **`web`**.

## The Why
- **Repeatable**: no more “what did I run last time?” Playbooks are a saved recipe.
- **Idempotent**: re-running a playbook doesn’t break anything; it just ensures the end state.
- **Fewer perms issues**: install packages with sudo, but run the app as the normal user to avoid `EACCES` headaches.
- **Fast troubleshooting**: tiny steps, verify often.

## Problem We’re Solving

We wanted to progress from basic connectivity to **automated configuration + app run** on targets.

* Manual SSH leads to drift and mistakes.
* Ad-hoc commands solve quick one-offs; **playbooks** solve repeatability.
* Using **private IPs** and **idempotent modules** reduces breakage between runs.

## 1) Preparing the Environment

1. Start **controller** and **app** VMs.
2. SSH to both in separate terminals.
3. Confirm Security Group rules:

   * **SSH (22)** open (classroom: `0.0.0.0/0` OK; prod: restrict).
   * **HTTP (80)** open to test Nginx/app.

> **Why:** Without correct ingress, Ansible/HTTP checks will fail even if playbooks are perfect.

## 2) Update the Inventory (Private IP)

```ini
# /etc/ansible/hosts
[web]
172.31.25.63

[web:vars]
ansible_user=ubuntu
ansible_ssh_private_key_file=~/.ssh/my-key.pem
```

Test:

```bash
ansible web -m ping
```

> **Why:** **Private IPs** don’t change on stop/start; fewer edits to inventory.

## 3) Ad-Hoc Commands

### Example 1 — Check Linux Version

```bash
ansible web -a "uname -a"
ansible web -m command -a "uname -a"
```

> **Why:** Quick, targeted checks without writing a playbook.

### Example 2 — Run an Update (non-idempotent)

```bash
ansible web -a "apt-get update -y" --become
```

> **Why:** Works, but prefer idempotent modules so re-runs are safe.

## 4) Using Idempotent Modules (Best Practice)

```bash
ansible web -m apt -a "update_cache=yes" --become
ansible web -m apt -a "upgrade=dist" --become
```

> **Why:** Idempotence = safe re-runs; fewer unintended changes.

## 5) Creating Our First Playbook — Install Nginx

```yaml
- name: Install Nginx
  hosts: web
  gather_facts: true
  become: true
  tasks:
    - apt: { update_cache: yes }
    - apt: { upgrade: dist }
    - apt: { name: nginx, state: present }
```

SSH into your controller node and cd into etc/ansible/

Run:

```bash
sudo nano install_nginx.yml
```
In the file that opens up, paste the playbook created above (install nginx)
Save and exit (ctrl+c, ctrl + x)

Run:
```bash
ansible-playbook install_nginx.yml
```

> **Why:** Encodes steps we can run (and re-run) consistently.

## 6) Creating a Playbook to Print Facts

```yaml
- name: Print Facts
  hosts: all
  gather_facts: true
  tasks:
    - debug: { var: ansible_facts }
```

> **Why:** Facts help us branch logic (OS family, IPs, memory, etc.).

## 7) Expanding the Inventory — DB and Parent Groups

```ini
[db]
172.31.45.210

[test:children]
web
db
```

> **Why:** Grouping lets us target whole environments (e.g., `ansible test -m ping`).

## 8) Verify Inventory Structure

```bash
ansible-inventory --list
ansible-inventory --graph
```

> **Why:** Catch inventory mistakes early.

## 9) The Reusable Recipe - How to Write Any Playbook

1. State the goal in one sentence
   *Example*: `Install Node.js and run my app.`

2. List the building blocks (modules)

     - Packages → apt

     - Files/dirs → file

     - Git repo → git

     - Run CLI in a folder → command/shell with args: chdir:

     - Node deps → npm

     - Services → service

3. Decide who runs each step

     - System changes → sudo (become: true)

     - App actions in home dir (git/npm/pm2) → normal user (become: false on those tasks)

4. Create a tiny skeleton:

  ```yaml
  name: my goal
  hosts: web
  gather_facts: true
  become: true
  tasks: []
  ```

5. Add tasks one at a time and after each small change:
     - SSH into your controller node, then cd into `etc/ansible/`. Once there, run `sudo nano my_play.yml` (as an example)
     - Paste your play in the file, then save (ctrl + c) and exit (ctrl + x)
     - Run `ansible-playbook my_play.yml` to check if it works.


      If it fails, fix that task before moving on.

6. Make it idempotent

     -  Use modules first (e.g., apt, git, npm).
     -  Use guards like creates: when you must call command/shell.

7. Verify with ad-hoc commands (node -v, curl, pm2 list, etc.).

    **Golden rule**: Small steps + frequent checks. It’s faster overall.

## Provision + Run the App (npm start)

Minimal, working playbook I used:

```yaml
- name: install app dependencies and run app
  hosts: web
  gather_facts: true
  become: true

  tasks:
    - name: update apt cache
      ansible.builtin.apt:
        update_cache: yes

    - name: upgrade all packages
      ansible.builtin.apt:
        upgrade: dist  # distributions

    - name: install nginx
      ansible.builtin.apt: pkg=nginx state=present

    - name: Download NodeSource setup script (Node.js 20.x)
      ansible.builtin.get_url:
        url: https://deb.nodesource.com/setup_20.x
        dest: /tmp/nodesource_setup.sh
        mode: '0755'

    - name: Install Node.js
      ansible.builtin.apt:
        name: nodejs
        state: present
        update_cache: yes

    - name: Clone the Sparta repo
      ansible.builtin.git:
        repo: https://github.com/laurenksmith/tech-511-lauren-first-app.git
        dest: ~/tech-511-lauren-first-app
        version: main
      become: false

    - name: Navigate to App folder and install Node.js dependencies
      ansible.builtin.npm:
        path: ~/tech-511-lauren-first-app/app
      become: false

    - name: Start Node app using npm start
      ansible.builtin.shell: npm start
      args:
        chdir: ~/tech-511-lauren-first-app/app
      become: false
```

## Provision + Run the App (PM2)

Same style, plus PM2 as a global tool and start via PM2:

```yaml
- name: install app dependencies and run app with pm2
  hosts: web
  gather_facts: true
  become: true

  tasks:
    - name: update apt cache
      ansible.builtin.apt:
        update_cache: yes

    - name: upgrade all packages
      ansible.builtin.apt:
        upgrade: dist

    - name: install nginx
      ansible.builtin.apt: pkg=nginx state=present

    - name: Download NodeSource setup script (Node.js 20.x)
      ansible.builtin.get_url:
        url: https://deb.nodesource.com/setup_20.x
        dest: /tmp/nodesource_setup.sh
        mode: '0755'

    - name: Install Node.js
      ansible.builtin.apt:
        name: nodejs
        state: present
        update_cache: yes

    - name: Clone the Sparta repo
      ansible.builtin.git:
        repo: https://github.com/laurenksmith/tech-511-lauren-first-app.git
        dest: ~/tech-511-lauren-first-app
        version: main
      become: false

    - name: Install app dependencies
      ansible.builtin.npm:
        path: ~/tech-511-lauren-first-app/app
      become: false

    - name: Install PM2 globally
      ansible.builtin.npm:
        name: pm2
        global: true

    - name: Stop app if running (ignore if not)
      ansible.builtin.shell: pm2 stop app || true
      become: false

    - name: Start app with PM2
      ansible.builtin.shell: pm2 start app.js --name app --update-env
      args:
        chdir: ~/tech-511-lauren-first-app/app
      # environment:
      #   DB_HOST: "mongodb://<DB_PRIVATE_IP>/posts"
      become: false

    - name: Save PM2 process list
      ansible.builtin.shell: pm2 save
      become: false
```

## Verifying It Works

If you have been able to run your finished playbook without errors:
1. Celebrate! Well done!
2. Go the the public ip address of the node you were testing (in this case, it was my app node). You should see the information expected there.

## Why & Benefits

### Why We Do It

* Replace manual SSH with **IaC** for **repeatability**.
* Ensure **consistent** app + infra setup across environments.
* Make changes **auditable** and **documented**.

### Benefits for Me

* Clear split: **Terraform builds**, **Ansible configures**.
* Faster debug: inventory checks, idempotent tasks, small reruns.
* Confidence converting bash scripts → Ansible tasks.

### Benefits for the Home Office

* **Consistency** across teams/environments.
* **Security-first**: least privilege for app tasks; managed processes.
* **Scalability**: run the same playbooks across many hosts.

## Troubleshooting Notes

| Symptom                          | Likely Cause                    | Fix                                                           |   |       |
| -------------------------------- | ------------------------------- | ------------------------------------------------------------- | - | ----- |
| `Connection timed out`           | SG/NACL blocking                | Open required ports (22/80)                                   |   |       |
| `Permission denied (publickey)`  | Wrong user/key/perms            | `ansible_user=ubuntu`, correct key, `chmod 400`               |   |       |
| Git “**dubious ownership**”      | Repo previously created by root | Delete & re-clone as `ubuntu` **or** `chown -R ubuntu:ubuntu` |   |       |
| `npm ERR! EACCES` during install | Directory owned by root         | Ensure repo cloned as `ubuntu`; run npm with `become: false`  |   |       |
| `Welcome to nginx!` on `/`       | Proxy not applied               | Check `lineinfile`, then `nginx -t` and restart               |   |       |
| `502 Bad Gateway`                | App not running / wrong port    | Check process (`pm2 list` or PID), `curl :3000`               |   |       |
| Port 3000 already in use         | Old process still running       | `fuser -k 3000/tcp                                            |   | true` |
| Playbook hangs on `npm start`    | Foreground start used           | Use `nohup` or switch to PM2                                  |   |       |


## Websites Used / References

* [Ansible Playbook Intro](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_intro.html)
* [Ansible Tutorial for Beginners](https://spacelift.io/blog/ansible-tutorial)
* [YAML Syntax Guide](https://docs.ansible.com/ansible/latest/reference_appendices/YAMLSyntax.html)
* [Using Ansible Playbooks](https://docs.ansible.com/ansible/latest/playbook_guide/index.html)
* [Ansible Playbooks: Complete Guide for Beginners](https://spacelift.io/blog/ansible-playbooks)