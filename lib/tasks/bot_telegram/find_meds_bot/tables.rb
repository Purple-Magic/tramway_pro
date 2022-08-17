# FIXME for some reason these lines create errors
unless Rails.env.test?
  require_relative 'tables/application_table'
  require_relative 'tables/main'
  require_relative 'tables/medicine'
end

module BotTelegram::FindMedsBot::Tables
end
