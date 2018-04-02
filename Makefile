deploy:
	ansible-playbook -i cm/inventory cm/deploy.yml
restart:
	ansible-playbook -i cm/inventory cm/restart.yml
