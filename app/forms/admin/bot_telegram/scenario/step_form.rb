class Admin::BotTelegram::Scenario::StepForm < Tramway::Core::ApplicationForm
  properties :name, :text, :file, :project_id, :delay
    
  association :bot

  def initialize(object)
    super(object).tap do
      form_properties bot: :association,
        name: :string,
        text: :text,
        file: :file,
        delay: {
          type: :default,
          input_options: {
            hint: I18n.t('hints.bot_telegram/scenario/step.delay')
          }
        }
    end
  end
end
