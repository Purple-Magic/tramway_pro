## Update ruby version

1. Update it in the Gemfile

*Gemfile*
```ruby
ruby '2.7.1'
```

2. Update it in ansible variables

*cm/production.yml*
```yaml
ruby_version: "ruby-2.7.1"
```

3. Install new version of ruby on the server

*server*
```
rvm install ruby-2.7.1
```

4. And deploy

*terminal*
```
make deploy
```
