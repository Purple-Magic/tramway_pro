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
run_love_chat_quest_ulsk_bot:
	rails r lib/tasks/chatquestsulsk/love/bot_listener.rb
run_detective_chat_quest_ulsk_bot:
	rails r lib/tasks/chatquestsulsk/detective/bot_listener.rb
run_fantasy_chat_quest_ulsk_bot:
	rails r lib/tasks/chatquestsulsk/fantasy/bot_listener.rb
run_horror_chat_quest_ulsk_bot:
	rails r lib/tasks/chatquestsulsk/horror/bot_listener.rb
run_rsm_project_office_bot:
	rails r lib/tasks/rsm/bot_listener.rb
