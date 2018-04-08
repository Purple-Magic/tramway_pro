deploy:
	ansible-playbook -i cm/inventory cm/deploy.yml
restart:
	ansible-playbook -i cm/inventory cm/restart.yml
install:
	#ansible-galaxy install -r cm/requirements.yml
	ansible-playbook -i cm/inventory cm/install.yml
