class ItWay::Person < ApplicationRecord
  belongs_to :star, class_name: 'Podcast::Star'
  belongs_to :telegram_user, class_name: 'BotTelegram::User'
  has_many :participations, class_name: 'ItWay::Participation'
  has_many :points, class_name: 'ItWay::People::Point'

  uploader :avatar, :photo, versions: [ :small, :medium ]
end
