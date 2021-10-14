# frozen_string_literal: true

class ContentStoriesWorker < ApplicationWorker
  sidekiq_options queue: :content

  include Ffmpeg::CommandBuilder
  include Podcast::SoundProcessConcern
  include BotTelegram::Leopold::Notify

  def perform(id)
    story = Content::Story.find id
    story.render
    chat_id = BotTelegram::Leopold::ChatDecorator::STORY_MAKER_ID
    send_notification_to_chat chat_id,
      notification(:story, :converted, **story.options_for_notification)
  end
end
