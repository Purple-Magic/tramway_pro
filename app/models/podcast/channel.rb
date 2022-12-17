class Podcast::Channel < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  scope :in_telegram, -> { where service: :telegram }

  enumerize :service, in: [ :telegram ]
end
