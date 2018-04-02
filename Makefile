deploy:
	ansible-playbook -i cm/inventory cm/deploy.yml -vvvv
restart:
	ansible-playbook -i cm/inventory cm/restart.yml
