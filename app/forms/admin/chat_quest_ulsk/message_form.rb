class Admin::ChatQuestUlsk::MessageForm < Tramway::Core::ApplicationForm
  properties :text, :area, :position, :project_id, :answer, :file

  def initialize(obj)
    super(obj).tap do
      form_properties text: :text,
        area: :default,
        position: :default,
        answer: :default,
        file: :file
    end
  end
end
