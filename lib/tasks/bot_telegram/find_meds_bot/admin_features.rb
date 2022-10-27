# frozen_string_literal: true

require_relative 'notify'

module BotTelegram::FindMedsBot::AdminFeatures
  include ::BotTelegram::FindMedsBot::Notify
  include ::BotTelegram::FindMedsBot::Concern
end
