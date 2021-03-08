# frozen_string_literal: true

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit].freeze

  belongs_to :podcast
  has_many :highlights, class_name: 'Podcast::Highlight'
end
