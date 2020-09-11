class BotTelegram::MessageDecorator < Tramway::Core::ApplicationDecorator
  decorate_associations :user

  class << self
    def list_attributes
      [ :created_at ]
    end
  end

  def title
    "#{user.title}: #{object.text&.first(15)...}"
  end

  def created_at
    object.created_at.in_time_zone('Samara').strftime('%d.%m.%Y %H:%M:%S')
  end
end
