# frozen_string_literal: true

class Podcast::Star < ApplicationRecord
  belongs_to :podcast, class_name: 'Podcast'
  has_many :social_networks, class_name: 'Tramway::Profiles::SocialNetwork', as: :record

  scope :podcast_scope, ->(_user_id) { all }

  store_accessor :profiles, :vk
  store_accessor :profiles, :twitter
  store_accessor :profiles, :telegram
  store_accessor :profiles, :instagram

  def name
    nickname
  end
end
