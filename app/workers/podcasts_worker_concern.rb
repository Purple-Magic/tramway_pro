# frozen_string_literal: true

module PodcastsWorkerConcern
  def render_full_video(episode)
    output = "#{@directory}/full_video.mp4"
    episode.render_full_video(output)

    Rails.logger.info 'Render full video completed'
  end
end
