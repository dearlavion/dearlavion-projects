#!/bin/bash

# ------------------------------
# CONFIGURATION
# ------------------------------
BASE_DIR="dearlavion-projects"

# Check if you're in the right directory
if [ "$(basename "$PWD")" != "$BASE_DIR" ]; then
  echo "❌ Please run this script from inside the '$BASE_DIR/' directory."
  exit 1
fi

# ------------------------------
# INPUT: Project name
# ------------------------------
read -p "Enter project name (e.g. n8n): " project

# ------------------------------
# Create project structure
# ------------------------------
mkdir -p $project/{src,scripts}
touch $project/{docker-compose.yml,Dockerfile,.env}
touch $project/scripts/update_ngrok_url.sh

# ------------------------------
# Create Ansible base structure
# ------------------------------
mkdir -p ansible/{roles/{app,docker}/tasks,group_vars,templates}

# Create inventory if not exists
if [ ! -f ansible/inventory.ini ]; then
  touch ansible/inventory.ini
  echo "# Inventory file" > ansible/inventory.ini
fi

# Add project to inventory.ini
if ! grep -q "\[$project\]" ansible/inventory.ini; then
  echo -e "\n[$project]" >> ansible/inventory.ini
  echo "localhost ansible_connection=local project_name=$project" >> ansible/inventory.ini
fi

# Create group vars file
cat <<EOF > ansible/group_vars/$project.yml
project_name: $project
project_path: "{{ playbook_dir }}/../$project"
compose_file: "{{ project_path }}/docker-compose.yml"
env_file: "{{ project_path }}/.env"
start_script: "{{ project_path }}/scripts/update_ngrok_url.sh"
EOF

# Create default task files if they don't exist
for role in app docker; do
  role_file="ansible/roles/$role/tasks/main.yml"
  if [ ! -f "$role_file" ]; then
    echo "---" > "$role_file"
  fi
done

# Create base playbook if it doesn't exist
if [ ! -f ansible/playbook.yml ]; then
  cat <<EOF > ansible/playbook.yml
---
- name: Deploy project
  hosts: all
  become: false

  roles:
    - docker
    - app
EOF
fi

# Optional: Create env template
touch ansible/templates/env.j2

# ------------------------------
# Done
# ------------------------------
echo "✅ Project '$project' initialized under '$BASE_DIR/' with Ansible support."
echo "📁 Structure created:"
echo "  - $project/"
echo "  - ansible/"