class Admin::Courses::LessonForm < Tramway::Core::ApplicationForm
  properties :title, :project_id

  association :topic

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        topic: :association
    end
  end
end
