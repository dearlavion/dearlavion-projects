# DearLavion Projects

This repository contains all projects managed with Docker + Ansible, including the n8n workflow service and the multi-service app dearlavion-app.
```plaintext
📁 Project Structure
dearlavion-projects/
├── dearlavion-app/
│   ├── dearlavion-authentication-service/
│   │   └── Dockerfile
│   ├── dearlavion-core-service/
│   │   └── Dockerfile
│   ├── dearlavion-web-ui/
│   │   └── Dockerfile
│   ├── nginx/
│   │   └── nginx.conf
|   ├── docker-compose.local.yml
│   ├── docker-compose.dev.yml
│   └── docker-compose.prod.yml
└── ansible/
    ├── inventory/
    │   └── hosts.ini
    ├── playbook/
    │   └── dearlavion-app.yml
    ├── group_vars/
    |   ├── dearlavion_local.yml
    │   ├── dearlavion_dev.yml
    │   └── dearlavion_prod.yml
    ├── roles/
    │   └── dearlavion/
    │       └── tasks/
    │           └── main.yml
    └── templates/
    └── env.j2
```

# ⚙️ Purpose

n8n/ – Standalone workflow automation service, deployed with Docker Compose.

dearlavion-app/ – Multi-service application containing:

dearlavion-authentication-service

dearlavion-core-service

dearlavion-web-ui (Angular 20)

nginx
Supports dev and prod Docker Compose environments.

ansible/ – Manages project environments and deployments for both dev and prod, including ngrok tunnels for local development.

# 🛠️ Init Script

The repository includes a project scaffolding script:

init-multiple-projects.sh

Features:

Create multiple projects in one run.

Supports custom subfolders per project.

Generates:

docker-compose.dev.yml, docker-compose.prod.yml, .env

Ansible roles, playbooks, group_vars

Inventory entries (_local and _prod)

ansible/templates/env.j2 if missing

# 🔹 Usage

Navigate to the repository root:

    ```bash
    cd ~/dearlavion-projects


Run the script:

    ```bash
    bash init-multiple-projects.sh


Follow prompts:

    ```bash
    Enter project names (comma-separated):
    Enter project names (comma-separated, e.g. dearlavion-app,myapp): dearlavion-app
    Enter subfolders for each project (comma-separated):
    Enter subfolders for dearlavion-app (comma-separated, e.g. backend-service-1,backend-service-2,frontend,nginx): backend-service-1,backend-service-2,frontend,nginx


Script creates all directories, files, and Ansible scaffolding automatically.
```plaintext
🔹 Example After Running
dearlavion-app/
├── backend-service-1/
├── backend-service-2/
├── frontend/
├── nginx/
├── docker-compose.dev.yml
├── docker-compose.prod.yml
└── .env
```

Ansible files under ansible/ are updated automatically.

# 🚀 Deployment Workflow
```plaintext
   ┌─────────────┐
   │   NGINX     │  :80
   │  (reverse)  │
   └──────┬──────┘
          │
    ┌─────┴──────────────┐
    │                    │
    │  Angular (static)  │
    │                    │
    └────────┬───────────┘
             │
    ┌──────┴──────┐   ┌──────┴─────┐
    │ Spring API  │   │ Spring API │
    │   service1  │   │  service2  │
    └─────────────┘   └────────────┘
```

Dev Environment – Auto-build & run on local:

    ```bash
    ansible-playbook ansible/playbook/dearlavion-dev.yml -i ansible/inventory/hosts.ini

Prod Environment – Manual deploy:

    ```bash
    ansible-playbook ansible/playbook/dearlavion-prod.yml -i ansible/inventory/hosts.ini

# ⚡ Notes

All projects support ngrok tunnels for local testing (use_ngrok: true in local group_vars).

Adding a new project is simple with init-multiple-projects.sh.

Dockerfiles are per service; nginx handles frontend + API proxy.
