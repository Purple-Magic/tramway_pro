# frozen_string_literal: true

class Admin::Benchkiller::CompanyForm < Tramway::Core::ApplicationForm
  properties :title, :email, :phone, :place, :portfolio_url, :company_url, :regions_to_cooperate, :project_id, :regions_to_except

  def initialize(object)
    super(object).tap do
      form_properties title: :text,
        email: :string,
        phone: :string,
        place: :string,
        company_url: :string,
        portfolio_url: :string,
        regions_to_cooperate: :string,
        regions_to_except: :string
    end
  end
end
