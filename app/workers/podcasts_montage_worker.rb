# frozen_string_literal: true

class PodcastsMontageWorker
  include Sidekiq::Worker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    filename = episode.convert_file

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')
    output = "#{directory}/montage.mp3"

    system "ffmpeg -y -i #{filename} -vcodec libx264 -af silenceremove=stop_periods=-1:stop_duration=1:stop_threshold=-30dB,acompressor=threshold=-12dB:ratio=2:attack=200:release=1000,volume=-0.5dB -b:a 320k #{output}"
  rescue StandardError => e
    Rails.env.development? ? puts(e) : Raven.capture_exception(e)
  end
end
