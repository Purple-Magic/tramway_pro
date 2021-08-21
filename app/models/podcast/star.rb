class Podcast::Star < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'
  has_and_belongs_to_many :stars, class_name: 'Podcast::Star'

  scope :podcast_scope, ->(_user_id) { all }

  def name
    nickname
  end
end
