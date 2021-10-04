class Admin::Content::StoryForm < Tramway::Core::ApplicationForm
  properties :original_file, :story, :project_id, :begin_time, :end_time, :converting_state

  def initialize(object)
    super(object).tap do
      form_properties original_file: :file,
        begin_time: :string,
        end_time: :string
    end
  end
end
