# frozen_string_literal: true

class Skillbox::CourseForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :team

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        team: :default
    end
  end
end
