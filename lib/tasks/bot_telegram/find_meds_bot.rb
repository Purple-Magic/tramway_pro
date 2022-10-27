# frozen_string_literal: true

module BotTelegram::FindMedsBot
  BUTTONS = {
    find_medicine: 'Поиск лекарств',
    start_menu: 'В начало',
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
    choose_concentration: {
      state: :waiting_for_choose_concentration
    },
    reinforcement: {
      state: :waiting_for_reinforcement
    },
    last_step: {
      state: :waiting_for_last_step
    },
    saving_feedback: {
      state: :waiting_for_saving_feedback
    }
  }.freeze

  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  PROJECT_ID = 7
  BOT_ID = 14

  class << self
    def menus
      config[:menus]
    end

    def developer_chat
      config[:developer_chat]
    end

    def config
      @config ||= YAML.load_file(config_file_path).with_indifferent_access
    end

    def config_file_path
      Rails.root.join('lib', 'tasks', 'bot_telegram', 'find_meds_bot', 'config.yml')
    end
  end
end
