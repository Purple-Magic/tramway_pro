# frozen_string_literal: true

module Benchkiller::CompaniesHelper
  def companies_title
    content_for :title do
      if @company.present?
        "#{@company.title} | Benchkiller"
      elsif @company_form.present?
        "#{@company_form.model.title} | Benchkiller"
      else
        "#{t('.title')} | Benchkiller"
      end
    end
  end
end
