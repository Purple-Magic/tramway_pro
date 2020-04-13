# Add project

#### 1. Add project to the `config/settings.yml`

```yaml
development:
  your_project: your-project.test
  
production:
  your_project: your-project.com # real domain name
  
test:
  your_project: your-project.test
```

#### 2. Add project to the database

```ruby
$> rails c
Project.create! title: 'Tramway', description: 'Main tramway application', url: 'tramway.test'
2.7.0 :001 > Project.create! title: 'Your project name', description: 'This is my application', url: 'your-project.com'
```

