# frozen_string_literal: true

class Admin::CourseForm < Tramway::Core::ApplicationForm
  properties :title, :state, :project_id, :team

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        team: :default
    end
  end
end
