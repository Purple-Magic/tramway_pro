# frozen_string_literal: true

class BotTelegram::BenchkillerBot::ChatDecorator
  def initialize(chat)
    @chat = chat
  end

  def to_answer?
    @chat.private?
  end
end
