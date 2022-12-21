# frozen_string_literal: true

class Podcasts::TrailerWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id)
    episode = Podcast::Episode.find id
    Podcasts::Episodes::Montage::AudioTrailerService.new(episode).call
  end
end
