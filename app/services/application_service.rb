# frozen_string_literal: true

class ApplicationService
  include BotTelegram::Leopold::Notify

  def initialize
    raise 'Please, implement initialize method'
  end

  def call
    raise 'Please, implement call method'
  end
end
