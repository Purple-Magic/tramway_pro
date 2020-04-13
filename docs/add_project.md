# Add project

#### 1. Add project to the `config/settings.yml`

```yaml
development:
  your_project: your-project.test
  engines:
    'your-project.test': engine_name # if your application is instance of some Tramway Engine
  application_class:
    'your-project.test: application_class # if your application does not use Tramway Engine
  
production:
  your_project: your-project.com # real domain name
  engines:
    'your-project.com': engine_name # if your application is instance of some Tramway Engine
  application_class:
    'your-project.com: application_class # if your application does not use Tramway Engine
  
test:
  your_project: your-project.test
  engines:
    'your-project.test': engine_name # if your application is instance of some Tramway Engine
  application_class:
    'your-project.test: application_class # if your application does not use Tramway Engine
```

#### 2. Add project to the database

```ruby
$> rails c
Project.create! title: 'Tramway', description: 'Main tramway application', url: 'tramway.test'
2.7.0 :001 > Project.create! title: 'Your project name', description: 'This is my application', url: 'your-project.com'
```

#### 3. Add routes to the `config/routes.rb`

```ruby
 constraints Constraints::DomainConstraint.new(Settings[Rails.env][:your_project]) do
   # your routes here
 end
```
#### 4. Update hosts. Edit `Makefile`

```make
install:
  echo "127.0.0.1 your-project.test" >> /etc/hosts
```

#### 5. Run rails server and open `your-project.test:3000` to test
