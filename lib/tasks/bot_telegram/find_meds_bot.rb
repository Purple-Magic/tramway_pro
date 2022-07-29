# frozen_string_literal: true

module BotTelegram::FindMedsBot
  MENUS = {
    start_menu: [
      [:find_medicine]
    ],
    find_medicine_menu: [
      [:start_menu]
    ]
  }.freeze

  BUTTONS = {
    find_medicine: 'Поиск лекарств',
    start_menu: 'Назад',
  }

  ACTIONS_DATA = {
    find_medicine: {
      message: 'Введите название лекарства на кириллице',
      state: :waiting_for_medicine_name
    }
  }

  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  PROJECT_ID = 7
  BOT_ID = 14
end
