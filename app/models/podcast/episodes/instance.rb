class Podcast::Episodes::Instance < ApplicationRecord
  belongs_to :episode, class_name: 'Podcast::Episode'
  has_many :shortened_urls, class_name: '::Shortener::ShortenedUrl', as: :owner

  enumerize :service, in: [ :yandex, :google, :youtube, :redcircle, :apple ]

  validates :link, url: true
end
