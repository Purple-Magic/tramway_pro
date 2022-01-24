class Podcasts::Episodes::Parts::PreviewWorker < ApplicationWorker
  sidekiq_options queue: :podcast

  include BotTelegram::Leopold::Notify

  def perform(id, output, *commands)
    commands.each do |command|
      job_id = Podcasts::Episodes::Parts::CommandWorker.perform_async command
      data = Sidekiq::Statuc::get_all job_id
      while data[:status] != 'complete'
        sleep 1
      end
    end

    part = Podcast::Episodes::Part.find id
    part.update_file! output, :preview

    chat_id = BotTelegram::Leopold::ChatDecorator::IT_WAY_PODCAST_ID
    send_notification_to_chat chat_id, notification(:part_preview, :finished)
  rescue StandardError => error
    Rails.env.development? ? puts(error) : Airbrake.notify(error)
  end
end
