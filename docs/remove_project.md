# How to remove project

For example: we destroy project Tik Tok (name: :tik_tok)

#### 1. Remove all Tramway initializers with this project

You can find initializers by argument `project: :tik_tok`

#### 2. Remove middleware `lib/middleware`, if exists with classes of its project)

All middlewares which working with classes in module TikTok must be deleted

#### 3. Remove it from `config/routes.rb`

*this code should be deleted*
```ruby
constraints Constraints::DomainConstraint.new(Settings[Rails.env][:tik_tok]) do
  # some routes
end
````

#### 4. Remove project from `config/settings.yml`

Everything with `tik_tok` key or its domain should be deleted

#### 5. Remove all tables about it

`rails generate migration remove_tik_tok_tables`

fill this migration and remove them with this migration

`rails db:migrate`

#### 6. Remove all assets belong to this project

#### 7. Remove all tests about this project
