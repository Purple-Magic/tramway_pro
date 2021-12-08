class Benchkiller::Web::CompaniesController < Benchkiller::Web::ApplicationController
  def show
    @company = ::Benchkiller::CompanyDecorator.new ::Benchkiller::Company.find_by uuid: params[:id]
    @company_has_user = @company.has_user? current_user.model
  end

  def edit
    @company_form = ::Benchkiller::Web::CompanyForm.new ::Benchkiller::Company.find_by uuid: params[:id]
  end

  def update
    @company_form = ::Benchkiller::Web::CompanyForm.new ::Benchkiller::Company.find_by uuid: params[:id]
    if @company_form.submit params[:benchkiller_company]
      redirect_to benchkiller_web_company_path(@company_form.model.uuid)
    else
      render :edit
    end
  end
end
