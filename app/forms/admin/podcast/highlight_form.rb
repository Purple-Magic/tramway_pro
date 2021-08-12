class Admin::Podcast::HighlightForm < Tramway::Core::ApplicationForm
  properties :using_state, :cut_begin_time, :cut_end_time, :trailer_position

  def initialize(object)
    super(objet).tap do
      form_properties using_state: :default,
        cut_begin_time: :text,
        cut_end_time: :text,
        trailer_position: :numeric
    end
  end
end
