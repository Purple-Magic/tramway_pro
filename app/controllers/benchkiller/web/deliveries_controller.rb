class Benchkiller::Web::DeliveriesController < Benchkiller::Web::ApplicationController
  def new
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.new
  end

  def create
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.new
    if @delivery_form.submit params[:benchkiller_delivery]
      redirect_to [benchkiller_web_offers_path, '?', { flash: :success_started_delivery }.to_query].join
    else
      redirect_to [new_benchkiller_web_delivery_path, '?', { flash: "errors: #{@delivery_form.errors}" }.to_query].join
    end
  end
end
