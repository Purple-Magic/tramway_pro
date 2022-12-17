class Podcast::Channel < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  enumerize :service, in: [ :telegram ]
end
