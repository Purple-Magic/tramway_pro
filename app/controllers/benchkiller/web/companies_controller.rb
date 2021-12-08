class Benchkiller::Web::CompaniesController < Benchkiller::Web::ApplicationController
  def show
    @company = ::Benchkiller::CompanyDecorator.new ::Benchkiller::Company.find_by uuid: params[:id]
  end
end
