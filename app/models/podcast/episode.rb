# frozen_string_literal: true

class Podcast::Episode < ApplicationRecord
  EPISODE_ATTRIBUTES = %i[title season number description published_at image explicit].freeze

  belongs_to :podcast
  has_many :highlights, class_name: 'Podcast::Highlight'

  uploader :file, :file, extensions: %i[ogg mp3 wav]

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
    filename = file.path.split('.')[0..-2].join('.')
    if file.path.split('.').last == 'ogg'
      filename += '.mp3'
      system "ffmpeg -i #{file.path} #{filename}"
    end
    highlights.each do |highlight|
      hour = highlight.time.split(':')[0]
      minutes = highlight.time.split(':')[1]
      seconds = highlight.time.split(':')[2]
      begin_time = (DateTime.new(2020, 0o1, 0o1, hour.to_i, minutes.to_i, seconds.to_i) - 2.minutes).strftime '%H:%M:%S'
      end_time = highlight.time
      system "ffmpeg -i #{filename} -ss #{begin_time} -to #{end_time} -c copy #{Rails.root}/public/#{podcast.title}-#{episode.number}-part-#{index + 1}.mp3"
    end
  end
end
