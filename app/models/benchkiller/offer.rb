class Benchkiller::Offer < ApplicationRecord
  belongs_to :message, class_name: 'BotTelegram::Message'
  has_and_belongs_to_many :tags, class_name: 'Benchkiller::Tag'

  scope :benchkiller_scope, lambda { |_user| all }

  search_by message: [ :text ]
end
