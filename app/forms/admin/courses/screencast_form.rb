# frozen_string_literal: true

class Admin::Courses::ScreencastForm < Tramway::Core::ApplicationForm
  properties :project_id, :scenario, :begin_time, :end_time, :file, :comment

  association :video

  def initialize(object)
    super(object).tap do
      form_properties video: :association,
        begin_time: :string,
        end_time: :string,
        file: :file,
        comment: :string
    end
  end
end
