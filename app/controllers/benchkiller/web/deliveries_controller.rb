class Benchkiller::Web::DeliveriesController < Benchkiller::Web::ApplicationController
  def new
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.new
  end

  def create
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.new
    params[:benchkiller_delivery][:benchkiller_user_id] = session['benchkiller/user_id']
    if @delivery_form.submit params[:benchkiller_delivery]
      @delivery_form.model.reload
      redirect_to benchkiller_web_delivery_path(@delivery_form.model.uuid)
    else
      render :new
    end
  end

  def show
    @delivery = ::Benchkiller::DeliveryDecorator.decorate ::Benchkiller::Delivery.find_by uuid: params[:id]
  end

  def edit
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.find_by uuid: params[:id]
  end

  def update
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.find_by uuid: params[:id]
    if @delivery_form.submit params[:benchkiller_delivery]
      @delivery_form.model.reload
      redirect_to benchkiller_web_delivery_path(@delivery_form.model.uuid)
    else
      render :edit
    end
  end
end
