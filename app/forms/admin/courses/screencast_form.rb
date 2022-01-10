class Admin::Courses::ScreencastForm < Tramway::Core::ApplicationForm
  properties :project_id, :scenario

  association :video

  def initialize(object)
    super(object).tap do
      form_properties video: :association,
        scenario: :text
    end
  end
end
