# frozen_string_literal: true

class Benchkiller::Benchkiller::CompanyForm < Tramway::ApplicationForm
  properties :title, :email, :phone, :place, :portfolio_url, :company_url, :regions_to_cooperate, :project_id,
    :regions_to_except

  def initialize(object)
    super(object).tap do
      form_properties title: :string,
        email: :string,
        phone: :string,
        place: :string,
        company_url: :string,
        portfolio_url: :string,
        regions_to_cooperate: {
          type: :string,
          input_options: {
            placeholder: 'Введите список стран через запятую без пробелов'
          }
        },
        regions_to_except: {
          type: :string,
          input_options: {
            placeholder: 'Введите список стран через запятую без пробелов'
          }
        }
    end
  end
end
