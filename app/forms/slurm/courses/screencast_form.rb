# frozen_string_literal: true

class Slurm::Courses::ScreencastForm < Tramway::Core::ApplicationForm
  properties :project_id, :scenario, :begin_time, :end_time, :file

  association :video

  def initialize(object)
    super(object).tap do
      form_properties video: :association,
        begin_time: :string,
        end_time: :string,
        file: :file
    end
  end
end
