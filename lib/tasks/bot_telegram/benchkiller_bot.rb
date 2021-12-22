# frozen_string_literal: true

module BotTelegram::BenchkillerBot
  PROJECT_ID = 7

  BOT_ID = 13

  MAIN_CHAT_ID = '-1001076312571'
  ADMIN_CHAT_ID = '-671956366'
  FREE_DEV_CHANNEL = '-1001424055607'
  NEED_DEV_CHANNEL = '-1001376858073'

  ACTIONS_DATA = {
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
    set_place: {
      message: 'Введите расположение вашей команды. Для отмены введите /start',
      state: :waiting_for_set_place
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

  def benchkiller_user(telegram_user)
    @benchkiller_user ||= ::Benchkiller::User.find_by bot_telegram_user_id: telegram_user.id
  end

  def company(telegram_user)
    benchkiller_user(telegram_user)&.companies&.first
  end
end
