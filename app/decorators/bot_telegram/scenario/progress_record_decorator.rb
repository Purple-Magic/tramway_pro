class BotTelegram::Scenario::ProgressRecordDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :user

  def title
    "#{user.title}: #{object.answer&.first(15)...}"
  end
end
