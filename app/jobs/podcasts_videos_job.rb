# frozen_string_literal: true

class PodcastsVideosJob < ActiveJob::Base
  queue_as :default

  def perform(id)
    episode = ::Podcast::Episode.find id

    episode.prepare_directory
    command = "ffmpeg #{options(episode)}"
    binding.pry
      #"-y -loop 1 -i #{episode.cover.path} -i #{episode.ready_file.path} -c:v libx264 -tune stillimage -c:a aac -b:a 192k -pix_fmt yuv420p -shortest -strict -2 #{output}" 
    system command
  rescue StandardError => e
    Rails.env.development? ? Rails.logger.error("logger.info : #{e.message}") : Raven.capture_exception(e)
  end

  private

  include Ffmpeg::CommandBuilder

  def options(episode)
    inputs = [episode.cover.path, episode.ready_file.path]
    output = "#{episode.parts_directory_name}/video.mp4"
    options_line(
      inputs: inputs,
      output: output,
      yes: true,
      loop_value: 1,
      video_codec: :libx264,
      tune: :stillimage,
      audio_codec: :aac,
      bitrate_audio: '192k',
      pixel_format: 'yuv420p',
      shortest: true,
      strict: 2
    )
  end
end
