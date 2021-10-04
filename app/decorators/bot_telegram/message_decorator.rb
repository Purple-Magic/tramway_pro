# frozen_string_literal: true

class BotTelegram::MessageDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :text

  decorate_associations :user

  class << self
    def list_attributes
      %i[bot text telegram_chat_id created_at]
    end
  end

  def bot
    object.bot&.name
  end

  def title
    "#{user.title}: #{object.text&.first(15)...}"
  end

  def created_at
    object.created_at.in_time_zone('Samara').strftime('%d.%m.%Y %H:%M:%S')
  end

  def telegram_chat_id
    object.chat.telegram_chat_id
  end
end
