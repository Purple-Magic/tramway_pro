# frozen_string_literal: true

class BotTelegram::BenchkillerBot::Command
  COMMANDS = %i[
    start
    create_company
    set_company_name
    set_company_url
    set_portfolio_url
    set_email
    set_phone
    set_place
    set_regions_to_cooperate
    get_company_card
    create_password
    approve_offer
    decline_offer
  ].freeze

  attr_reader :name, :argument

  def initialize(message, slug)
    if message.is_a? Telegram::Bot::Types::CallbackQuery
      data = JSON.parse(message.data).with_indifferent_access
      @name = COMMANDS.select do |com|
        data[:command] == com.to_s
      end.first

      raise 'There is not such command' unless @name.present?

      @argument = data[:argument]
    else
      @name = COMMANDS.map do |com|
        com if message.text&.match?(%r{^/#{com}})
      end.compact.first
      @argument = message.text.present? ? message.text.gsub(%r{^/#{@name} }, '').gsub(/^@#{slug}/, '') : []
    end
  end

  def valid?
    @name.present?
  end
end
