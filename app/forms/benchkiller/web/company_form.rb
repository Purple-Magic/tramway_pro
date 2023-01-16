# frozen_string_literal: true

class Benchkiller::Web::CompanyForm < Tramway::ApplicationForm
  properties :title, :company_url, :email, :place, :portfolio_url, :phone, :regions_to_cooperate
end
