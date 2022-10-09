class FindMeds::FeedbackForm < Tramway::Core::ApplicationForm
  include ::BotTelegram::Leopold::Notify

  properties :text, :data

  def submit(params)
    super
    send_notification_to_chat(
      ::BotTelegram::FindMedsBot::DEVELOPER_CHAT,
      'test'
    )
  end
end
