# Usage examples
# Run n8n on local
# make run PROJECT=n8n ENV=local

# Stop n8n on prod
# make stop PROJECT=n8n ENV=prod

# Rebuild grafana on local
# make rebuild PROJECT=grafana ENV=local


# Set default values if not provided
PROJECT ?= n8n
ENV ?= local
INVENTORY = inventory/hosts.ini

# Derive dynamic values
PLAYBOOK = playbook/$(PROJECT).yml
TARGET_GROUP = $(PROJECT)_$(ENV)

# Generic commands
run:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --tags start -e "target_host=$(TARGET_GROUP) target_group_file=$(TARGET_GROUP) env_name=$(ENV)"

stop:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --tags stop -e "target_host=$(TARGET_GROUP) target_group_file=$(TARGET_GROUP) env_name=$(ENV)"

rebuild:
	ansible-playbook $(PLAYBOOK) -i $(INVENTORY) --tags rebuild -e "target_host=$(TARGET_GROUP) target_group_file=$(TARGET_GROUP) env_name=$(ENV)"

# Convenience aliases for frontend
# make frontend-run
frontend-run:
	ansible-playbook playbook/frontend.yml --ask-become-pass --tags start

frontend-stop:
	ansible-playbook playbook/frontend.yml --ask-become-pass --tags stop
