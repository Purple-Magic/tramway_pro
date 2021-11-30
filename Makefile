deploy_production:
	ansible-playbook -i deploy/inventory deploy/deploy.yml
restart_production:
	ansible-playbook -i deploy/inventory deploy/restart.yml
install:
	sudo apt-get install imagemagick
configure:
	cp config/database.sample.yml config/database.yml
	cp config/secrets.sample.yml config/secrets.yml
	cp config/sidekiq.sample.yml config/sidekiq.yml
	echo "You should run it with sudo"
	echo "127.0.0.1	it-way.test" >> /etc/hosts
	echo "127.0.0.1 sportschool-ulsk.test" >> /etc/hosts
	echo "127.0.0.1 kalashnikovisme.test" >> /etc/hosts
	echo "127.0.0.1 tramway.test" >> /etc/hosts
	echo "127.0.0.1 engineervol.test" >> /etc/hosts
	echo "127.0.0.1	purple-magic.test" >> /etc/hosts
	echo "127.0.0.1 gorodsad73.test" >> /etc/hosts
	echo "127.0.0.1	red-magic.test" >> /etc/hosts
	echo "127.0.0.1	freedvs.test" >> /etc/hosts
restore_production:
	bin/prod get_db $(USER)
	rails db:seed

run_telegram_bots:
	bundle exec rails r lib/tasks/bot_telegram/start_bots.rb
run_telegram_bot:
	bundle exec sidekiq &
	bundle exec rails r "bot = Bot.find($(BOT)); BotJob.perform_later bot.id, bot.name; puts :started"
stop_telegram_bots:
	sh stop_telegram_bots.sh
restart_telegram_bot:
	make stop_telegram_bots | sleep 1; make run_telegram_bot
restart_telegram_bots:
	make stop_telegram_bots
	make run_telegram_bots

code_check:
	rubocop -A
	reek

prepare_test_env:
	RAILS_ENV=test rails db:create db:migrate db:seed
