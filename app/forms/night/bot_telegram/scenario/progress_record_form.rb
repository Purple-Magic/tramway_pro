# frozen_string_literal: true

class Night::BotTelegram::Scenario::ProgressRecordForm < Tramway::Core::ApplicationForm
  properties :answer

  association :step
  association :user

  def initialize(object)
    super(object).tap do
      form_properties user: :association,
        step: :association,
        answer: :text
    end
  end
end
