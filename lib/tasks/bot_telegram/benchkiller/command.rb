# frozen_string_literal: true

class BotTelegram::Benchkiller::Command
  COMMANDS = %w[start].freeze

  attr_reader :name, :argument

  def initialize(message, slug)
    if message.text.present?
      @name = COMMANDS.map do |com|
        com if message.text&.match?(%r{^/#{com}})
      end.compact.first
      @argument = message.text.present? ? message.text.gsub(%r{^/#{@name} }, '').gsub(/^@#{slug}/, '') : []
    elsif message.data.present?
    end
  end

  def valid?
    @name.present?
  end
end
