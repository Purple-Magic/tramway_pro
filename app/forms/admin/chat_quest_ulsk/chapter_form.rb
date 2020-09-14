class Admin::ChatQuestUlsk::ChapterForm < Tramway::Core::ApplicationForm
  properties :quest, :position, :project_id

  def initialize(object)
    super(object).tap do
      form_properties quest: :default,
        position: :numeric
    end
  end
end
