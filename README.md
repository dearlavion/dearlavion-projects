# 🚀 Ansible Project Initializer

This script sets up a ready-to-use Ansible + Docker project structure.

---

## ✅ How to Use

1. **Save the script**

   Save the script as `init-ansible-project.sh` in your `dearlavion-projects/` directory.

2. **Make it executable**

   ```bash
   chmod +x init-ansible-project.sh

3. **Run the script**

   ```bash
   ./init-ansible-project.sh

4. **🧱 After running, your structure will be:**

    ```plaintext
    📁 Project Structure
    
    dearlavion-projects/
    ├── n8n/
    │   ├── docker-compose.yml
    │   ├── Dockerfile
    │   ├── .env
    │   ├── src/
    │   └── scripts/
    └── ansible/
        ├── inventory/
        │   └── hosts.ini
        ├── playbook/
        │   └── n8n.yml
        ├── group_vars/
        │   ├── n8n_local.yml
        │   └── n8n_prod.yml
        ├── roles/
        │   ├── n8n/
        │   │   └── tasks/
        │   │       └── main.yml
        │   ├── docker/
        │   │   └── tasks/
        │   │       └── main.yml
        │   └── ngrok/
        │       └── tasks/
        │           └── main.yml
        └── templates/
            └── env.j2
    ```

5. **Run the project later with:**

   ```bash
   ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --limit n8n


6. **Helpful Ansible commands while developing**


   * Check syntax (valid YAML and playbook syntax):

      ```bash
      ansible-playbook playbook.yml --syntax-check

   * Dry run (check mode):

      ```bash
      ansible-playbook -i inventory.ini playbook.yml --limit n8n --check

   * Verbose output (useful for debugging):

      ```bash
      ansible-playbook -i inventory.ini playbook.yml --limit n8n -vvv


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
   
   