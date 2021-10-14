# frozen_string_literal: true

class BotTelegram::Benchkiller::Command
  COMMANDS = %w[start].freeze

  attr_reader :name, :argument

  def initialize(text, slug)
    @name = COMMANDS.map do |com|
      com if text&.match?(%r{^/#{com}})
    end.compact.first
    @argument = text.present? ? text.gsub(%r{^/#{@name} }, '').gsub(/^@#{slug}/, '') : []
  end

  def valid?
    @name.present?
  end
end
