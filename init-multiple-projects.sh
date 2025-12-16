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
# INPUT: Projects
# ------------------------------
read -p "Enter project names (comma-separated, e.g. dearlavion-app,myapp): " projects_input

# Convert comma-separated string to array
IFS=',' read -r -a projects <<< "$projects_input"

# ------------------------------
# Function to create project
# ------------------------------
create_project() {
  local project="$1"
  project=$(echo "$project" | tr '[:upper:]' '[:lower:]' | tr -cd '[:alnum:]_-')
  echo "🔹 Creating project: $project"

  # --- Ask for subfolders ---
  read -p "Enter subfolders for $project (comma-separated, e.g. backend-service-1,backend-service-2,frontend,nginx): " subfolders_input
  IFS=',' read -r -a subfolders <<< "$subfolders_input"

  # --- Create folder structure dynamically ---
  for folder in "${subfolders[@]}"; do
      mkdir -p "$project/$folder"
  done

  # --- Create docker-compose & env placeholders ---
  touch "$project"/docker-compose.dev.yml
  touch "$project"/docker-compose.prod.yml
  touch "$project"/.env

  # --- Create Ansible structure ---
  mkdir -p ansible/roles/"$project"/tasks
  mkdir -p ansible/{inventory,playbook,group_vars,templates}

  # --- Inventory setup ---
  inventory_file="ansible/inventory/hosts.ini"
  [ ! -f "$inventory_file" ] && echo "# Ansible inventory" > "$inventory_file"

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

  # --- Group vars ---
  cat <<EOF > ansible/group_vars/${project}_local.yml
use_ngrok: true
compose_file: docker-compose.dev.yml
app_path: "{{ lookup('env','PWD') }}/$project"
EOF

  cat <<EOF > ansible/group_vars/${project}_prod.yml
use_ngrok: false
compose_file: docker-compose.prod.yml
app_path: "{{ lookup('env','PWD') }}/$project"
EOF

  # --- Role tasks ---
  role_tasks="ansible/roles/$project/tasks/main.yml"
  [ ! -f "$role_tasks" ] && echo "---" > "$role_tasks"

  # --- Playbook ---
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
    # Ensure trailing newline
    echo "" >> "$playbook_file"
  fi

  # --- Env template ---
  [ ! -f ansible/templates/env.j2 ] && touch ansible/templates/env.j2

  echo "✅ Project '$project' initialized!"
  echo ""
}

# ------------------------------
# Loop through all projects
# ------------------------------
for project in "${projects[@]}"; do
  create_project "$project"
done

echo "🎉 All projects initialized!"
