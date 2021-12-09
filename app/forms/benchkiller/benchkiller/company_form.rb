# frozen_string_literal: true

class Admin::Benchkiller::CompanyForm < Tramway::Core::ApplicationForm
  properties :title, :email, :phone, :place, :portfolio_url, :regions_to_cooperate

  def initialize(object)
    super(object).tap do
      form_properties title: :text,
        email: :string,
        phone: :string,
        place: :string,
        portfolio_url: :string,
        regions_to_cooperate: :string
    end
  end
end
