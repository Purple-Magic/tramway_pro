# frozen_string_literal: true

class Admin::BotTelegram::Scenario::StepForm < Tramway::Core::ApplicationForm
  properties :name, :text, :file, :project_id, :delay, :options, :reply_markup

  association :bot

  def initialize(object)
    super(object).tap do
      form_properties bot: :association,
        name: :string,
        text: :text,
        file: :file,
        options: :text,
        reply_markup: :text,
        delay: {
          type: :default,
          input_options: {
            hint: I18n.t('hints.bot_telegram/scenario/step.delay')
          }
        }
    end
  end

  def options=(value)
    model.options = YAML.safe_load(value)
  end

  def options
    YAML.dump(model.options).sub("---\n", '')
  end

  def reply_markup=(value)
    model.reply_markup = YAML.safe_load(value)
  end

  def reply_markup
    YAML.dump(model.reply_markup).sub("---\n", '')
  end
end
