# frozen_string_literal: true

class Admin::Podcast::HighlightForm < Tramway::Core::ApplicationForm
  properties :using_state, :cut_begin_time, :cut_end_time, :trailer_position, :project_id, :time

  association :episode

  def initialize(object)
    super(object).tap do
      form_properties using_state: :default,
        cut_begin_time: :string,
        cut_end_time: :string,
        trailer_position: :numeric,
        time: :string
    end
  end
end
