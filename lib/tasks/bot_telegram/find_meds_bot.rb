# frozen_string_literal: true

module BotTelegram::FindMedsBot
  VALIDATIONS = {
    url: lambda do |value|
      value.present? && value.match?(URI::DEFAULT_PARSER.make_regexp(%w[http https]))
    end,
    just_text: ->(value) { value.present? }
  }.freeze

  class << self
    def menus
      config[:menus]
    end

    def developer_chat
      config[:developer_chat]
    end

    def buttons
      config[:buttons]
    end

    def actions_data
      config[:actions_data]
    end

    def project_id
      config[:project_id]
    end

    def bot_id
      config[:bot_id]
    end

    def config
      @config ||= YAML.load_file(config_file_path).with_indifferent_access
    end

    def config_file_path
      Rails.root.join('lib', 'tasks', 'bot_telegram', 'find_meds_bot', 'config.yml')
    end
  end
end
