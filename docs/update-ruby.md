## Update ruby version

1. Update it in the Gemfile

*Gemfile*
```ruby
ruby '2.7.6'
```

2. Update it in ansible variables

*deploy/production.yml*
```yaml
ruby_version: "ruby-2.7.6"
```

3. Update ruby version in restart bots script

*restart_bots.sh*
```
cd /srv/tramway_pro/current && /bin/bash -ilc '/usr/share/rvm/bin/rvm ruby-2.7.6 do bundle exec sidekiq -C /srv/tramway_pro/current/config/sidekiq.yml &'
```

4. Install new version of ruby on the server

*server*
```
rvm install ruby-2.7.6
```

5. And deploy

*terminal*
```
make deploy
```
