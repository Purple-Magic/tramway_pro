# frozen_string_literal: true

class Podcasts::FinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub('//', '/')

    output = "#{directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Trailer file does not exist for #{index} seconds"
    end

    episode.update_file! output, :ready_file

    episode.make_audio_ready
    episode.save!

    output = "#{directory}/trailer.mp4"
    episode.render_video_trailer(output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Video Trailer file does not exist for #{index} seconds"
    end

    episode.update_file! output, :trailer_video

    episode.make_video_trailer_ready
    episode.save!

    output = "#{directory}/full_video.mp4"
    episode.render_full_video(output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Full video file does not exist for #{index} seconds"
    end

    episode.update_file! output, :full_video

    episode.finish
    episode.save!
  end
end
