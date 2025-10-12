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
mkdir -p ansible/roles/{docker,ngrok,"$project"/tasks}

# ------------------------------
# Inventory setup
# ------------------------------
inventory_file="ansible/inventory/hosts.ini"

if [ ! -f "$inventory_file" ]; then
  echo "# Ansible inventory" > "$inventory_file"
fi

# Add local group to inventory
if ! grep -q "[$project"_local"]" "$inventory_file"; then
  echo -e "\n[${project}_local]" >> "$inventory_file"
  echo "localhost ansible_connection=local" >> "$inventory_file"
fi

# Add public group to inventory
if ! grep -q "[$project"_public"]" "$inventory_file"; then
  echo -e "\n[${project}_public]" >> "$inventory_file"
  echo "#your_public_host ansible_user=ubuntu" >> "$inventory_file"
fi

# ------------------------------
# Create group_vars files
# ------------------------------
cat <<EOF > ansible/group_vars/${project}_local.yml
${project}_port: 5678
use_ngrok: true
EOF

cat <<EOF > ansible/group_vars/${project}_public.yml
${project}_port: 5678
use_ngrok: false
EOF

# ------------------------------
# Create empty main.yml files for roles
# ------------------------------
for role in docker ngrok "$project"; do
  role_tasks="ansible/roles/$role/tasks/main.yml"
  if [ ! -f "$role_tasks" ]; then
    echo "---" > "$role_tasks"
  fi
done

# ------------------------------
# Create playbook for the project
# ------------------------------
playbook_file="ansible/playbook/${project}.yml"

if [ ! -f "$playbook_file" ]; then
  cat <<EOF > "$playbook_file"
---
- name: Setup $project environment
  hosts: ${project}_local  # or ${project}_public
  become: true

  roles:
    - docker
    - $project
    - { role: ngrok, when: use_ngrok | default(false) }
EOF
fi

# ------------------------------
# Create env template (optional)
# ------------------------------
touch ansible/templates/env.j2

# ------------------------------
# Done
# ------------------------------
echo "✅ Project '$project' initialized under '$BASE_DIR/' with Ansible support."
echo "📁 Structure created:"
echo "  - $project/"
echo "  - ansible/"