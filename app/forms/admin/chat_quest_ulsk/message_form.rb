class Admin::ChatQuestUlsk::MessageForm < Tramway::Core::ApplicationForm
  properties :text, :area, :position, :project_id, :answers

  def initialize(obj)
    super(obj).tap do
      form_properties text: :text,
        area: :default,
        position: :default,
        answers: :default
    end
  end
end
