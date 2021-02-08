# frozen_string_literal: true

class Night::BotTelegram::Scenario::StepForm < Tramway::Core::ApplicationForm
  properties :name, :text, :file, :delay, :project_id, :options

  association :bot

  def initialize(object)
    super(object).tap do
      form_properties bot: :association,
                      name: :string,
                      text: :text,
                      file: :file,
                      options: :text,
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
end
