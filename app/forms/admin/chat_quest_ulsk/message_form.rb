class Admin::ChatQuestUlsk::MessageForm < Tramway::Core::ApplicationForm
  properties :text, :area, :position, :project_id

  def initialize(obj)
    super(obj).tap do
      form_properties text: :text,
        area: :default,
        position: :default
    end
  end
end
