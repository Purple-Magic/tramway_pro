# frozen_string_literal: true

class Podcasts::YoutubePublishWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  def perform(id)
    episode = Podcast::Episode.find id
    
    Podcasts::Youtube::PublishService.new(episode).call
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end
