class Admin::ChatQuestUlsk::MessageForm < Tramway::Core::ApplicationForm
  properties :text, :quest, :position, :project_id, :answer, :file

  def initialize(obj)
    super(obj).tap do
      form_properties text: :text,
        quest: :default,
        position: :default,
        answer: :default,
        file: :file
    end
  end
end
