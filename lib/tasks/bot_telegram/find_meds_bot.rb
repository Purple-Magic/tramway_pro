# frozen_string_literal: true

module BotTelegram::FindMedsBot
  MENUS = {
    start_menu: [
      %i[find_medicine about]
    ],
    find_medicine_menu: [
      [:start_menu]
    ]
  }.freeze

  BUTTONS = {
    find_medicine: 'Поиск лекарств',
    start_menu: 'Назад',
    about: 'О проекте'
  }.freeze

  ACTIONS_DATA = {
    find_medicine: {
      message: 'Убедитесь, что название написано правильно',
      state: :waiting_for_medicine_name
    },
    choose_company: {
      state: :waiting_for_choose_company
    },
    choose_form: {
      state: :waiting_for_choose_form
    },
  }.freeze

  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  PROJECT_ID = 7
  BOT_ID = 14
end
