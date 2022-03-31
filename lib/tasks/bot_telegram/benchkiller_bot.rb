# frozen_string_literal: true

module BotTelegram::BenchkillerBot
  PROJECT_ID = 7

  BOT_ID = 13

  MAIN_CHAT_ID = '-1001076312571'
  ADMIN_CHAT_ID = '-671956366'
  ADMIN_COMPANIES_CHAT_ID = '-624830465'
  FREE_DEV_CHANNEL = '-1001424055607'
  NEED_DEV_CHANNEL = '-1001376858073'

  MAIN_COUNTRIES = [ 'РФ', 'Украина', 'Белоруссия' ]
  CONTINENTS = { europa: 'Европа', asia: 'Азия', america: 'Америка' }

  EUROPA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['europa']
  ASIA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['asia'] 
  AMERICA_COUNTRIES = YAML.load_file(Rails.root.join('lib', 'yaml', 'benchkiller_countries.yml'))['america'] 
  
  MENUS = {
    start_menu: [
      %i[get_company_card create_password],
      [:change_company_card]
    ],
    change_company_card: [
      %i[set_company_name set_phone],
      %i[set_company_url set_place],
      %i[set_portfolio_url set_regions_to_cooperate],
      %i[set_email start_menu]
    ],
    set_place_menu: [ :add_place, :remove_place ],
    add_place_menu: (CONTINENTS.keys + MAIN_COUNTRIES).each_slice(3).to_a,
    set_regions_to_cooperate_menu: CONTINENTS.keys + MAIN_COUNTRIES,
    europa: [:whole_europa] + EUROPA_COUNTRIES.each_slice(3).to_a,
    asia: ['Вся Азия'] + ASIA_COUNTRIES,
    america: ['Вся Америка'] + AMERICA_COUNTRIES,
    without_company_menu: [
      [:create_company]
    ]
  }.freeze

  BUTTONS = {
    add_place: 'Добавить место расположение',
    remove_place: 'Удалить место расположения',
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
    start_menu: 'Назад',
    whole_europa: '🇪🇺Вся Европа'
  }.merge(CONTINENTS.reduce({}) { |hash, (key, continent)| hash.merge! key => continent })
    .merge(MAIN_COUNTRIES.reduce({}) { |hash, continent| hash.merge! continent => continent })
    .merge(EUROPA_COUNTRIES.reduce({}) { |hash, country| hash.merge! country => country })
    .merge(ASIA_COUNTRIES.reduce({}) { |hash, country| hash.merge! country => country })
    .merge(AMERICA_COUNTRIES.reduce({}) { |hash, country| hash.merge! country => country })

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
    },
    set_regions_to_cooperate: {
      message: 'Введите регионы сотрудничества. Для отмены введите /start',
      state: :waiting_for_set_regions_to_cooperate
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
    { name: :place, validation: VALIDATIONS[:just_text] },
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
