# frozen_string_literal: true

class BotTelegram::Leopold::Command
  include ::BotTelegram::Leopold::Commands

  COMMANDS = %w[add_word add_description add_synonims].freeze

  attr_reader :name, :argument, :bot

  def initialize(text, slug, bot)
    @bot = bot
    @name = COMMANDS.map do |com|
      com if text&.match?(%r{^/#{com}})
    end.compact.first
    @argument = text.present? ? text.gsub(%r{^/#{@name} }, '').gsub(/^@#{slug}/, '') : []
  end

  def valid?
    @name.present?
  end

  def run
    public_send name, argument
  end
end
