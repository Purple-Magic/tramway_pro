# frozen_string_literal: true

class Admin::Estimation::TaskForm < Tramway::ApplicationForm
  properties :title, :hours, :price, :project_id, :specialists_count, :description, :task_type

  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
        title: :string,
        hours: :numeric,
        price: :numeric,
        specialists_count: :numeric,
        description: :text,
        task_type: :default
    end
  end
end
