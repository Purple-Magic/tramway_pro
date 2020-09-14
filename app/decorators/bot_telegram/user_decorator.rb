# frozen_string_literal: true

class BotTelegram::UserDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes :username, :first_name, :last_name

  def title
    "#{username.present? ? username : 'No username'}: #{first_name} #{last_name}"
  end

  decorate_associations :messages

  class << self
    def show_associations
      [:messages]
    end
  end
end
