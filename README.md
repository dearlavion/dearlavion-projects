✅ How to use

Save the script as init-ansible-project.sh in your dearlavion-projects/ folder.

Make it executable:

chmod +x init-ansible-project.sh


Run it:

./init-ansible-project.sh

🧱 After running, your structure will be:
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

✅ Run the project later with:
ansible-playbook -i ansible/inventory.ini ansible/playbook.yml --limit n8n