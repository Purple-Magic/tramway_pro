# frozen_string_literal: true

class PodcastsMontageJob < ActiveJob::Base
  def perform(id)
    episode = Podcast::Episode.find id

    filename = episode.convert_file

    output = "#{directory}/montage.mp3"

    system "ffmpeg -y -i #{filename} -c:a libx264 -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB #{output}"
  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
