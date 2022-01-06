# frozen_string_literal: true

class BotTelegram::Scenario::ProgressRecordDecorator < ApplicationDecorator
  decorate_associations :user

  def title
    "#{user.title}: #{object.answer&.first(15)...}"
  end
end
