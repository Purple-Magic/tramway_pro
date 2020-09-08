class BotTelegram::MessageDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :user

  def title
    "#{user.title}: #{object.text.first(15)...}"
  end
end
