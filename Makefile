deploy:
	ansible-playbook -i cm/inventory cm/deploy.yml
restart:
	ansible-playbook -i cm/inventory cm/restart.yml
install:
	echo "You should run it with sudo"
	echo "127.0.0.1	it-way.test" >> /etc/hosts
	echo "127.0.0.1 sportschool-ulsk.test" >> /etc/hosts
	echo "127.0.0.1 kalashnikovisme.test" >> /etc/hosts
	echo "127.0.0.1 tramway.test" >> /etc/hosts
	echo "127.0.0.1 engineervol.test" >> /etc/hosts
	echo "127.0.0.1	purple-magic.test" >> /etc/hosts
	echo "127.0.0.1 gorodsad73.test" >> /etc/hosts
restore_production:
	bin/prod get_db $(USER)
	rails db:seed

run_telegram_bots:
	bundle exec rails r lib/tasks/bot_telegram/start_bots.rb
stop_telegram_bots:
	sh stop_telegram_bots.sh
restart_telegram_bots:
	make run_telegram_bots
	make stop_telegram_bots
