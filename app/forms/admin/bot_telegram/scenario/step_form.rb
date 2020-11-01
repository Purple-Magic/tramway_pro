class Admin::BotTelegram::Scenario::StepForm < Tramway::Core::ApplicationForm
  properties :name, :text, :file
    
  association :bot

  def initialize(object)
    super(object).tap do
      form_properties bot: :association,
        name: :string,
        text: :text,
        file: :file
    end
  end
end
