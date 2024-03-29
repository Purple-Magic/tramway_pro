# Tramway based applications 

| Project | URL | Tests | Smell Check | Linter | Syntax Check |
|---------|-----|----|----|----|----|
| IT Way | [it-way.pro](it-way.pro) |  |
| ULSK Quest Fantasy | [t.me/questfantasy_bot](t.me/questfantasy_bot) |  |
| ULSK Quest Horror | [t.me/questhorror_bot](t.me/questhorror_bot) |  |
| ULSK Quest Love | [t.me/questlove_bot](t.me/questlove_bot) |  |
| ULSK Quest Detective | [t.me/questhorror_bot](t.me/questhorror_bot) |  |
| ULSK Quest Uncle Mitya | [t.me/questnewyearbot](t.me/questnewyearbot) |  |

### Install && run

```shell
make install
bundle
rails db:create db:migrate
bundle exec rails s
```

Open:
* IT Way -> `it-way.test:3000`
* kalashnikovisme -> `kalashnikovisme.test:3000`
* tramway -> `tramway.test:3000`

To fill db run:

```
bin/prod get_db tramway
```

### Install && run tests

```shell
make install
bundle
RAILS_ENV=test rails db:create db:migrate db:seed
bundle exec rspec
```

### Before commit don't forget

```shell
make code_check
```

### Run production environment locally

1. Change all domains in docker/web/nginx.conf to `.test` domain zone
2. Change all domains in config/environments/production.rb to `.test` zone
3. Change all domains in config/settings.yml to `.test` zone

### Воркфлоу работы с гемами tramway

В случае, если изменения требуется сделать в гемах tramway, у задачи в trello будет стоять Метка `tramway`. Ссылка на [все карточки](https://trello.com/b/HVkPer5c/%D0%B3%D0%BE%D0%B4-%D0%BC%D0%BE%D0%BB%D0%BE%D0%B4%D1%8B%D1%85-2020?menu=filter&filter=label:tramway)

Для того, чтобы делать изменения в гемах и тестировать их сразу в проектах, нужно работать следующим образом.

#### 1. Клонируем репозиторий tramway себе на машину и кладём репозиторий рядом с проектом

```
git clone git@github.com:ulmic/tramway-dev директория_где_лежит_проект
```

#### 2. Переносим все гемы tramway в Gemfile на директорию рядом с проектом. Ссылки там уже есть, они закомментированы

```ruby
gem 'tramway-admin', path: '../tramway-dev/tramway-admin'
gem 'tramway-auth', path: '../tramway-dev/tramway-auth'
gem 'tramway-core', path: '../tramway-dev/tramway-core'
gem 'tramway-event', path: '../tramway-dev/tramway-event'
gem 'tramway-export', path: '../tramway-dev/tramway-export'
gem 'tramway-landing', path: '../tramway-dev/tramway-landing'
gem 'tramway-profiles', path: '../tramway-dev/tramway-profiles'
gem 'tramway-user', path: '../tramway-dev/tramway-user'

#gem 'tramway-admin', '1.18.4.3'
#gem 'tramway-auth', '1.1.0.2'
#gem 'tramway-core', '1.14.5.2'
#gem 'tramway-event', '1.9.19.6'
#gem 'tramway-export', '0.1.0.1'
#gem 'tramway-landing', '1.8.2'
#gem 'tramway-profiles', '1.3.1'
#gem 'tramway-user', '2.1.0.1'
```

#### 3. Делаем bundle

Теперь весь код гемов можно редактировать и тестировать прямо в репозитории, который у вас на локальной машине. Он будет подгружаться автоматически. Перезагрузка сервера нужна только в случаях, если в принципе в Rails в таких кейсах нужна перезагрузка.

#### 4. После всех изменений запускаем тесты, чтобы проверить, что всё работает

#### 5. Коммитим в репозиторий tramway-dev
#### 6. Делаем PR в ветку develop в репозитории tramway-dev
#### 7. После код-ревью делаем мерж в ветку develop
#### 8. Увеличиваем версию гема в соответствии с принципами семантического версионирования (мажорная.минорная.патч.фикс) в файле #{gem_name}/lib/#{gem_name}/version.rb
    * мажорная версия - версия, ломающая обратную совместимость гема
    * минорная версия - реализация новой фичи в геме
    * обновление какой-либо фичи гема
    * фикс - исправлен баг

#### 9. Деплоим обновлённую версию гема (для этого нужно авторизоваться в rubygems.org)

Лучше эту команду повесить на алиас в .bashrc

```shell
rm -rf *.gem && gem build $(basename "$PWD").gemspec && gem push *.gem
```

#### 10. Обновляем версию гема в проекте (гем не сразу станет доступен для установки из rubygems, у них индексы долго обновляются), снова прогоняем тесты, коммитим в ветку develop

#### 11. Создаём новый релиз через утилиту [git flow](https://github.com/nvie/gitflow)

```shell
git describe --abbrev=0 --tags # смотрим последний релиз
git flow release start (номер релиза в соответствии с семантическим версионированием)
git flow release finish (номер релиза в соответствии с семантическим версионированием)
git push origin develop
git push origin master
make deploy
```

### Наименование коммитов

* Коммиты следует именовать, начиная с `#{номер_карточки_в_trello} описание вашего коммита``
* Не забудьте поставить пробел в начале коммит сообщения, а то ваше сообщение будет считаться комментарием

## More Instructions

* [How to add project](https://github.com/Purple-Magic/tramway_pro/blob/develop/docs/add_project.md)
* [How to remove project](https://github.com/Purple-Magic/tramway_pro/blob/develop/docs/remove_project.md)
* [Update ruby version](https://github.com/Purple-Magic/tramway_pro/blob/develop/docs/update-ruby.md)
* [How to change favicon on IT Way](https://github.com/Purple-Magic/tramway_pro/blob/develop/docs/change_favicon_on_it_way.md)
* [How to change trello butler action one line jsons](https://github.com/Purple-Magic/tramway_pro/blob/develop/docs/trello_butler_actions.md)

## Troubleshooting

### Middlewares issue

You have this `ActiveSupport::Concern::MultipleIncludedBlocks (Cannot define multiple 'included' blocks for a Concern)`
It means that you should rename your middleware file and class to another. Looks like it's some kind of constant name conflict.

### Role scope issue

If you have issue looks like this `#{user.role}_scope undefined for ActiveRecord::Relation[]` you should add this scope in `lib/middleware/multi_project_configuration_middleware/event.rb` at `ParticipantConcern` and restart server
