class BotTelegram::Users::State < ApplicationRecord
  belongs_to :user, class_name: 'BotTelegram::User'
  belongs_to :bot, class_name: 'Bot'
end
