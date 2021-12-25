class Television::ScheduleItem < ApplicationRecord
  belongs_to :channel, class_name: 'Television::Channel'
  belongs_to :video, class_name: 'Television::Video'

  enumerize :schedule_type, in: [ 'order', 'time' ]

  store_accessor :options, :position

  def command
    "ffmpeg -re -i /mnt/volume_fra1_01/video/#{video.id}/file.mp4 -c:v libx264 -g 4 -b:v 4500k -preset ultrafast -f flv rtmp://a.rtmp.youtube.com/live2/t4t2-gk0t-x7y2-0qd8-f5kr"
  end
end
