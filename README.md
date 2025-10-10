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
   dearlavion-projects/
   ├── n8n/
   │   ├── docker-compose.yml
   │   ├── Dockerfile
   │   ├── .env
   │   ├── src/
   │   └── scripts/
   │       └── update_ngrok_url.sh
   └── ansible/
       ├── inventory.ini
       ├── playbook.yml
       ├── group_vars/
       │   └── n8n.yml
       ├── roles/
       │   ├── app/
       │   │   └── tasks/main.yml
       │   └── docker/
       │       └── tasks/main.yml
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
   
   