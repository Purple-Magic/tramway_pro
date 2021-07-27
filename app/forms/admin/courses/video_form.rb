class Admin::Courses::VideoForm < Tramway::Core::ApplicationForm
  properties :text, :project_id

  association :lesson

  def initialize(object)
    super(object).tap do
      form_properties lesson: :association,
        text: :ckeditor
    end
  end
end
