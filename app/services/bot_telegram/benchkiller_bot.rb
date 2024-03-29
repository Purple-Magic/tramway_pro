# frozen_string_literal: true

module BotTelegram::BenchkillerBot
  PROJECT_ID = 7

  BOT_ID = 13

  MAIN_CHAT_ID = '-1001076312571'
  ADMIN_CHAT_ID = '-671956366'
  ADMIN_COMPANIES_CHAT_ID = '-624830465'
  FREE_DEV_CHANNEL = '-1001424055607'
  NEED_DEV_CHANNEL = '-1001376858073'

  MAIN_COUNTRIES = { russia: 'РФ', ukraine: 'Украина', belarus: 'Беларусь' }.freeze
  CONTINENTS = { europa: 'Европа', asia: 'Азия', america: 'Америка' }.freeze

  EUROPA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['europa']
  ASIA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['asia']
  AMERICA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['america']

  WHOLE_COUNTRIES = {
    whole_europa: 'Вся Европа',
    whole_asia: 'Вся Азия',
    whole_america: 'Вся Америка',
    mena: 'MENA',
    worldwide: 'Worldwide'
  }.freeze

  ALL_COUNTRIES = MAIN_COUNTRIES.merge(EUROPA_COUNTRIES).merge(ASIA_COUNTRIES).merge(AMERICA_COUNTRIES).merge(WHOLE_COUNTRIES)

  MENUS = {
    start_menu: [
      %i[get_company_card],
      [:change_company_card]
    ],
    change_company_card: [
      %i[set_company_name set_phone],
      %i[set_company_url set_place],
      %i[set_portfolio_url set_regions_to_cooperate set_regions_to_except],
      %i[set_email start_menu]
    ],
    set_place_menu: %i[add_place remove_place],
    add_place_menu: [:worldwide] + (CONTINENTS.keys + MAIN_COUNTRIES.keys).each_slice(3).to_a,
    set_regions_to_cooperate_menu: %i[add_region_to_cooperate remove_region_to_cooperate],
    add_region_to_cooperate_menu: [:worldwide] + (CONTINENTS.keys + MAIN_COUNTRIES.keys).each_slice(3).to_a,
    set_regions_to_except_menu: %i[add_region_to_except remove_region_to_except],
    add_region_to_except_menu: [:worldwide] + (CONTINENTS.keys + MAIN_COUNTRIES.keys).each_slice(3).to_a,
    europa: [:whole_europa] + EUROPA_COUNTRIES.keys.each_slice(3).to_a,
    asia: %i[whole_asia mena] + ASIA_COUNTRIES.keys.each_slice(3).to_a,
    america: [:whole_america] + AMERICA_COUNTRIES.keys.each_slice(3).to_a,
    without_company_menu: [
      [:create_company]
    ]
  }.freeze

  BUTTONS = {
    add_place: 'Добавить место расположение',
    remove_place: 'Удалить место расположения',
    add_region_to_cooperate: 'Добавить регион сотрудничества',
    remove_region_to_cooperate: 'Удалить регион сотрудничества',
    add_region_to_except: 'Добавить регион-исключение',
    remove_region_to_except: 'Удалить регион-исключение',
    change_company_card: 'Изменить карточку',
    create_company: 'Создать компанию',
    create_password: 'Сгенерировать пароль',
    get_company_card: 'Карточка компании',
    manage_subscription: 'Управление подпиской',
    set_company_name: 'Название компании',
    set_portfolio_url: 'Портфолио',
    set_company_url: 'Сайт',
    set_email: 'Почта',
    set_place: 'Расположение компании',
    set_phone: 'Телефон',
    set_regions_to_cooperate: 'Регионы сотрудничества',
    set_regions_to_except: 'Регионы-исключения',
    start_menu: 'Назад'
  }.merge(CONTINENTS.reduce({}) { |hash, (key, continent)| hash.merge! key => continent })
            .merge(MAIN_COUNTRIES.reduce({}) { |hash, (key, country)| hash.merge! key => country })
            .merge(EUROPA_COUNTRIES.reduce({}) { |hash, (key, country)| hash.merge! key => country })
            .merge(ASIA_COUNTRIES.reduce({}) { |hash, (key, country)| hash.merge! key => country })
            .merge(AMERICA_COUNTRIES.reduce({}) { |hash, (key, country)| hash.merge! key => country })
            .merge(WHOLE_COUNTRIES.reduce({}) { |hash, (key, country)| hash.merge! key => country })

  ACTIONS_DATA = {
    create_company: {
      message: 'Введите название компании. Для отмены введите /start',
      state: :waiting_for_create_company
    },
    set_company_name: {
      message: 'Введите название компании. Для отмены введите /start',
      state: :waiting_for_set_company_name
    },
    set_portfolio_url: {
      message: 'Введите ссылку на портфолио. Для отмены введите /start',
      state: :waiting_for_set_portfolio_url
    },
    set_company_url: {
      message: 'Введите адрес сайта компании. Для отмены введите /start',
      state: :waiting_for_set_company_url
    },
    set_email: {
      message: 'Введите контактный email. Для отмены введите /start',
      state: :waiting_for_set_email
    },
    set_phone: {
      message: 'Введите контактный телефон. Для отмены введите /start',
      state: :waiting_for_set_phone
    }
  }.freeze

  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  ATTRIBUTES_DATA = [
    { name: :portfolio_url, validation: VALIDATIONS[:url] },
    { name: :company_url, validation: VALIDATIONS[:url] },
    { name: :phone, validation: VALIDATIONS[:just_text] },
    { name: :regions_to_cooperate, validation: VALIDATIONS[:just_text] },
    {
      name: :email,
      validation: lambda do |value|
        value.present? && value.scan(URI::MailTo::EMAIL_REGEXP).present?
      end
    }
  ].freeze

  def benchkiller_user(telegram_user)
    @benchkiller_user ||= ::Benchkiller::User.find_by bot_telegram_user_id: telegram_user.id
  end

  def company(telegram_user)
    benchkiller_user(telegram_user)&.companies&.first
  end
end
