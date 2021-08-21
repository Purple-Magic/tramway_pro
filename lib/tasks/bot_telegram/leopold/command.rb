# frozen_string_literal: true

class BotTelegram::Leopold::Command
  include ::BotTelegram::Leopold::Commands

  COMMANDS = %w[add_word add_description add_synonims].freeze

  def initialize(text)
    @name =  COMMANDS.map do |com|
      com if text&.match?(%r{^/#{com}})
    end.compact.first
    @argument = text.gsub(%r{^/#{command} }, '').gsub(/^@myleopold_bot/, '')
  end

  def valid?
    @name.present?
  end

  def run
    public_send @name, @argument
  end
end
