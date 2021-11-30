class Benchkiller::Web::DeliveriesController < Benchkiller::Web::ApplicationController
  def new
    if params[:receivers_ids].present?
      @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.new
    else
      redirect_to [benchkiller_web_offers_path, '?', { flash: :no_offer_checked }.to_query].join
    end
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

  def run_process
    @delivery = ::Benchkiller::Delivery.find_by uuid: params[:id]
    if params[:process].in? [ 'run', 'send_to_me' ]
      @delivery.public_send(params[:process])
    end
    case params[:process]
    when 'run'
      redirect_to [benchkiller_web_offers_path, '?', { flash: :success_started_delivery }.to_query].join
    when 'send_to_me'
      redirect_to benchkiller_web_delivery_path(@delivery.uuid)
    end
  end
end
