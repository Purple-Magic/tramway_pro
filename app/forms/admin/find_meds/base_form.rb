# frozen_string_literal: true

class Admin::FindMeds::BaseForm < Tramway::ApplicationForm
  properties :name, :key, :project_id

  def initialize(object)
    super(object).tap do
      form_properties name: :string,
        key: :string
    end
  end
end
