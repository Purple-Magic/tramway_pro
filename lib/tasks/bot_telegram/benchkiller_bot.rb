# frozen_string_literal: true

module BotTelegram::BenchkillerBot
  PROJECT_ID = 7

  ACTIONS_DATA = {
    set_company_name: {
      message: 'Введите название компании',
      state: :waiting_for_set_company_name
    },
    set_portfolio_url: {
      message: 'Введите ссылку на портфолио',
      state: :waiting_for_set_portfolio_url
    },
    set_company_url: {
      message: 'Введите адрес сайта компании',
      state: :waiting_for_set_company_url
    },
    set_email: {
      message: 'Введите контактный email',
      state: :waiting_for_set_email
    },
    set_place: {
      message: 'Введите расположение вашей команды',
      state: :waiting_for_set_place
    },
    set_phone: {
      message: 'Введите контактный телефон',
      state: :waiting_for_set_phone
    },
    set_regions_to_cooperate: {
      message: 'Введите регионы сотрудничества',
      state: :waiting_for_set_regions_to_cooperate
    }
  }

  def benchkiller_user(telegram_user)
    @benchkiller_user ||= ::Benchkiller::User.active.find_by bot_telegram_user_id: telegram_user.id
  end

  def company(telegram_user)
    benchkiller_user(telegram_user)&.companies.first
  end
end
