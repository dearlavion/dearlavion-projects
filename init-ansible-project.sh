#!/bin/bash

# ------------------------------
# CONFIGURATION
# ------------------------------
BASE_DIR="dearlavion-projects"

# Ensure script is run from inside BASE_DIR
if [ "$(basename "$PWD")" != "$BASE_DIR" ]; then
  echo "❌ Please run this script from inside the '$BASE_DIR/' directory."
  exit 1
fi

# ------------------------------
# INPUT: Project name
# ------------------------------
read -p "Enter new project name (e.g. myapp): " project
project=$(echo "$project" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]_-')

# ------------------------------
# Create project directory
# ------------------------------
mkdir -p "$project"/{src,scripts}
touch "$project"/{docker-compose.yml,Dockerfile,.env}

# ------------------------------
# Create Ansible structure (if not exists)
# ------------------------------
mkdir -p ansible/{inventory,playbook,group_vars,templates}
mkdir -p ansible/roles/"$project"/tasks

# ------------------------------
# Inventory setup
# ------------------------------
inventory_file="ansible/inventory/hosts.ini"

if [ ! -f "$inventory_file" ]; then
  echo "# Ansible inventory" > "$inventory_file"
  echo "# The filename inside group_vars/ corresponds to an inventory group name." >> "$inventory_file"
fi

# Add project local group
if ! grep -q "\[${project}_local\]" "$inventory_file"; then
  echo -e "\n[${project}_local]" >> "$inventory_file"
  echo "localhost ansible_connection=local project_name=$project env=local" >> "$inventory_file"
fi

# Add project prod group
if ! grep -q "\[${project}_prod\]" "$inventory_file"; then
  echo -e "\n[${project}_prod]" >> "$inventory_file"
  echo "#prod-server ansible_connection=ssh ansible_user=ubuntu project_name=$project env=prod" >> "$inventory_file"
fi

# Add ngrok local group
if ! grep -q "\[ngrok_local\]" "$inventory_file"; then
  echo -e "\n[ngrok_local]" >> "$inventory_file"
  echo "localhost ansible_connection=local project_name=$project env=local" >> "$inventory_file"
fi

# Add ngrok prod group
if ! grep -q "\[ngrok_prod\]" "$inventory_file"; then
  echo -e "\n[ngrok_prod]" >> "$inventory_file"
  echo "#your_prod_host ansible_user=ubuntu project_name=$project env=prod" >> "$inventory_file"
fi

# ------------------------------
# Create group_vars files
# ------------------------------
cat <<EOF > ansible/group_vars/${project}_local.yml
use_ngrok: true
ngrok_authtoken: "your-ngrok-authtoken-here"
local_port: 5678
EOF

cat <<EOF > ansible/group_vars/${project}_prod.yml
use_ngrok: false
local_port: 5678
EOF

# ------------------------------
# Create empty main.yml for project role
# ------------------------------
role_tasks="ansible/roles/$project/tasks/main.yml"
if [ ! -f "$role_tasks" ]; then
  echo "---" > "$role_tasks"
fi

# ------------------------------
# Create project-specific playbook
# ------------------------------
playbook_file="ansible/playbook/${project}.yml"

if [ ! -f "$playbook_file" ]; then
  cat <<EOF > "$playbook_file"
---
- name: Setup $project environment
  hosts: ${project}_local  # or ${project}_prod
  become: true

  roles:
    - $project
    - { role: ngrok, when: use_ngrok | default(false) }
EOF
fi

# ------------------------------
# Create env template (optional)
# ------------------------------
if [ ! -f ansible/templates/env.j2 ]; then
  touch ansible/templates/env.j2
fi

# ------------------------------
# Done
# ------------------------------
echo "✅ Project '$project' initialized under '$BASE_DIR/' with Ansible support."
echo "📁 Structure created:"
echo "  - $project/"
echo "  - ansible/"