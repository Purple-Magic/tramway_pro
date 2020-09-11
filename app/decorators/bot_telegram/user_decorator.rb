class BotTelegram::UserDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :username, :first_name, :last_name

  alias title username

  decorate_associations :messages

  class << self
    def show_associations
      [ :messages ]
    end
  end
end
