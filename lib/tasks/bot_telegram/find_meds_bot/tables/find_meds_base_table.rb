# frozen_string_literal: true

class BotTelegram::FindMedsBot::Tables::FindMedsBaseTable < BotTelegram::FindMedsBot::Tables::ApplicationTable
  def name
    self.Name
  end
end
