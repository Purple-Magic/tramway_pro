# frozen_string_literal: true

require_relative '../../lib/tasks/bot_telegram/bot_listener'

class BotWorker < ApplicationWorker
  sidekiq_options queue: :bot

  def perform(id, _bot_name)
    BotTelegram::BotListener.perform id
  end

  def self.cancel!(jid)
    Sidekiq.redis { |can| can.setex("cancelled-#{jid}", 86_400, 1) }
  end
end
