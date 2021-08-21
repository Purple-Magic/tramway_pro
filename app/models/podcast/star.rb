class Podcast::Star < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'

  scope :podcast_scope, ->(_user_id) { all }
end
