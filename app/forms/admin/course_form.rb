# frozen_string_literal: true

class Admin::CourseForm < Tramway::Core::ExtendedApplicationForm
  properties :title, :state, :project_id, :team, :logging_actions

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        team: :default,
        logging_actions: :string
    end
  end

  def logging_actions
    model.options&.dig('logging_actions')
  end

  def logging_actions=(actions)
    model.options ||= {}
    model.options.merge! logging_actions: actions
    model.save!
  end
end
