class PodcastsFinishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id

    directory = episode.prepare_directory
    directory = directory.gsub("//", '/')

    output = "#{directory}/ready_file.mp3"
    episode.concat_trailer_and_episode(output)

    index = 0
    until File.exist?(output)
      sleep 1
      index += 1
      Rails.logger.info "Trailer file does not exist for #{index} seconds"
    end

    File.open(output) do |f|
      episode.ready_file = f
    end

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

    File.open(output) do |f|
      episode.trailer_video = f
    end

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

    File.open(output) do |f|
      episode.full_video = f
    end

    episode.finish
    episode.save!
  end
end
