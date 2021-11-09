class Benchkiller::Offer < ApplicationRecord
  belongs_to :message, class_name: 'BotTelegram::Message'

  scope :benchkiller_scope, lambda { |_user| all }

  search_by message: [ :text ]
end
