ps aux | grep -ie sidekiq | awk '{print $2}' | xargs kill -9
cd /srv/tramway_pro/current && /bin/bash -ilc '/usr/share/rvm/bin/rvm ruby-2.7.6 do bundle exec sidekiq -C /srv/tramway_pro/current/config/sidekiq.yml &'
cd /srv/tramway_pro/current && /bin/bash -lic 'exec bundle exec rails runner /srv/tramway_pro/current/lib/tasks/bot_telegram/start_bots.rb'
