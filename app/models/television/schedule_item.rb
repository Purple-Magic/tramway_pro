class Television::ScheduleItem < ApplicationRecord
  belongs_to :channel, class_name: 'Television::Channel'
  belongs_to :video, class_name: 'Television::Video'

  enumerize :schedule_type, in: [ 'order', 'time' ]

  store_accessor :options, :position

  def command
    "ffmpeg -re -i /mnt/volume_fra1_01/video/#{video.id}/file.mp4 -c:v libx264 -g 4 -b:v 4500k -preset ultrafast -f flv #{channel.rtmp.url}/#{channel.rtmp.password}"
  end
end
