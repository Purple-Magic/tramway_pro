class Podcast::Episodes::Star < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'
  belongs_to :star, class_name: 'Podcast::Star'

  enumerize :star_type, in: [ :main, :guest, :minor ], default: :main

  delegate :vk, to: :star
  delegate :telegram, to: :star
  delegate :first_name, to: :star
  delegate :last_name, to: :star
  delegate :nickname, to: :star
  delegate :link, to: :star
  delegate :instagram, to: :star
  delegate :twitter, to: :star

  scope :main, -> { where star_type: :main }
  scope :guest, -> { where star_type: :guest }
  scope :minor, -> { where star_type: :minor }
end
