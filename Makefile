run:
	rails db:create
	rails db:migrate
	bundle exec puma

deploy_production:
	ansible-playbook -i deploy/inventory deploy/deploy.yml
	RAILS_ENV=production bundle exec rails assets:clean assets:precompile
	tar zcvf assets.tar.gz public/assets/
	ssh -t tramway@tramway.pro 'mkdir -p /srv/tramway_pro/current/public/assets/'
	scp assets.tar.gz tramway@tramway.pro:/srv/tramway_pro/current/assets.tar.gz
	ssh -t tramway@tramway.pro 'cd /srv/tramway_pro/current/ && tar zxvf assets.tar.gz'
	ssh -t tramway@tramway.pro 'rm /srv/tramway_pro/current/assets.tar.gz'
	rm assets.tar.gz
	tar zcvf packs.tar.gz public/packs/
	ssh -t tramway@tramway.pro 'mkdir -p /srv/tramway_pro/current/public/packs/'
	scp packs.tar.gz tramway@tramway.pro:/srv/tramway_pro/current/packs.tar.gz
	ssh -t tramway@tramway.pro 'cd /srv/tramway_pro/current/ && tar zxvf packs.tar.gz'
	ssh -t tramway@tramway.pro 'rm /srv/tramway_pro/current/packs.tar.gz'
	rm packs.tar.gz
	ansible-playbook -i deploy/inventory deploy/restart.yml

restart_production:
	ansible-playbook -i deploy/inventory deploy/restart.yml

install:
	sudo apt-get install imagemagick
	bundle install
	cp config/database.sample.yml config/database.yml
	cp config/secrets.sample.yml config/secrets.yml
	cp config/sidekiq.sample.yml config/sidekiq.yml
	rails db:create db:migrate
	echo "NOW! Run sudo make configure"

configure:
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
	bundle exec rubocop -A
	bundle exec reek

prepare_test_env:
	RAILS_ENV=test rails db:create db:migrate db:seed

docker_build_production:
	docker build . -t tramway_production

test:
	bundle exec rspec

ssh:
	ssh tramway@tramway.pro

run_production:
	docker-compose down
	POSTGRES_DB=tramway POSTGRES_PASSWORD=123 SECRET_KEY_BASE=123 docker-compose up
