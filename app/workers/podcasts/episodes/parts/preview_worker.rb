# frozen_string_literal: true

class Podcasts::Episodes::Parts::PreviewWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id, output, *commands)
    commands.each do |command|
      Podcasts::Episodes::Parts::CommandWorker.new.perform command
    end

    part = Podcast::Episodes::Part.find id
    part.update_file! output, :preview

    send_notification_to_chat part.episode.podcast.chat_id, notification(:part_preview, :finished)
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end
