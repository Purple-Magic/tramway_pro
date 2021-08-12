class Admin::Podcast::HighlightForm < Tramway::Core::ApplicationForm
  properties :using_state, :cut_begin_time, :cut_end_time, :trailer_position, :project_id

  def initialize(object)
    super(object).tap do
      form_properties using_state: :default,
        cut_begin_time: :string,
        cut_end_time: :string,
        trailer_position: :numeric
    end
  end
end
