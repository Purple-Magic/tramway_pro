# frozen_string_literal: true

class PodcastsVideosWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  version 1

  def perform(id)
    episode = ::Podcast::Episode.find id

    episode.prepare_directory
    command = "ffmpeg #{options(episode)}"
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
