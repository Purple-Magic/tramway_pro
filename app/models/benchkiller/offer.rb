class Benchkiller::Offer < ApplicationRecord
  belongs_to :message, class_name: 'BotTelegram::Message'

  search_by message: [ :text ]
end
