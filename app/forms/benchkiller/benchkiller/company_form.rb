# frozen_string_literal: true

class Admin::Benchkiller::CompanyForm < Tramway::Core::ApplicationForm
  properties :title, :data, :state, :project_id

  def initialize(object)
    super(object).tap do
      form_properties title: :text,
        data: :string,
        state: :text,
        project_id: :integer
    end
  end
end
