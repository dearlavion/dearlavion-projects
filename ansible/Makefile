# To execute: make rebuild-local

INVENTORY=inventory.ini

run-local:
	ansible-playbook -i $(INVENTORY) playbook.yml --limit n8n_local -e env_name=local

rebuild-local:
	ansible-playbook -i $(INVENTORY) playbook.yml --limit n8n_local --tags rebuild -e env_name=local

stop-local:
	ansible-playbook -i $(INVENTORY) playbook.yml --limit n8n_local --tags stop -e env_name=local

prod-deploy:
	ansible-playbook -i $(INVENTORY) playbook.yml --limit n8n_prod -e env_name=prod
