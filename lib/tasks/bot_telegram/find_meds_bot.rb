# frozen_string_literal: true

module BotTelegram::FindMedsBot
  MENUS = {
    start_menu: [
      [:find_medicine]
    ],
  }.freeze

  BUTTONS = {
    find_medicine: 'Поиск лекарств'
  }

  ACTIONS_DATA = {
  }.freeze

  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  ATTRIBUTES_DATA = [
  ].freeze

  PROJECT_ID = 7
  BOT_ID = 14

end
