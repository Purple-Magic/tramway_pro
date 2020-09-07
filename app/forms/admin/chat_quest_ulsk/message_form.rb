class Admin::ChatQuestUlsk::MessageForm < Tramway::Core::ApplicationForm
  properties :text, :area, :position, :project_id, :answer

  def initialize(obj)
    super(obj).tap do
      form_properties text: :text,
        area: :default,
        position: :default,
        answer: :default
    end
  end
end
