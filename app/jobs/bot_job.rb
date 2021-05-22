# frozen_string_literal: true

class BotJob < ActiveJob::Base
  queue_as :bot

  def perform(id)
    BotTelegram::BotListener.perform id
  end

  def self.cancel!(jid)
    Sidekiq.redis {|c| c.setex("cancelled-#{jid}", 86400, 1) }
  end
end
