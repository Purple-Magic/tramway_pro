# frozen_string_literal: true

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit].freeze

  belongs_to :podcast
  has_many :highlights, class_name: 'Podcast::Highlight'

  uploader :file, :file, extensions: [ :ogg, :mp3, :wav ]

  aasm column: :montage_state do
    state :recording, initial: true
    state :recorded
    state :montaged

    event :montage, before: :cut_highlights do
      transitions from: :recording, to: :montaged
      transitions from: :recorded, to: :montaged
    end
  end

  def cut_highlights
  end
end
