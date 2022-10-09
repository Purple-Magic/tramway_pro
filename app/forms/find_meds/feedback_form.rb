class FindMeds::FeedbackForm < Tramway::Core::ApplicationForm
  include ::BotTelegram::Leopold::Notify

  properties :text, :data

  def submit(params)
    super
    model.reload
    model.update! project_id: 7
    send_notification_to_chat(
      ::BotTelegram::FindMedsBot::DEVELOPER_CHAT,
      I18n.t('find_meds.bot.notifications.new_feedback', id: model.id)
    )
  end
end
