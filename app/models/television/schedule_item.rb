# frozen_string_literal: true

class Television::ScheduleItem < ApplicationRecord
  belongs_to :channel, class_name: 'Television::Channel'
  belongs_to :video, class_name: 'Television::Video'

  enumerize :schedule_type, in: %w[order time]

  store_accessor :options, :position

  def command
    "ffmpeg -re -i #{video.remote_file_path} -c:v libx264 -g 4 -b:v 4500k -preset ultrafast -f flv #{channel.url}/#{channel.password}"
  end
end
