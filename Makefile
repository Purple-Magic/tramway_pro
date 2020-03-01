deploy:
	ansible-playbook -i cm/inventory cm/deploy.yml
restart:
	ansible-playbook -i cm/inventory cm/restart.yml
install:
	echo "You should run it with sudo"
	echo "127.0.0.1 it-way.test" >> /etc/hosts
	echo "127.0.0.1 sportschool-ulsk.test" >> /etc/hosts

restore_production:
	bin/prod get_db $(USER)
	rails db:seed
