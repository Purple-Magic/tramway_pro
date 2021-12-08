# frozen_string_literal: true

class Benchkiller::Web::DeliveriesController < Benchkiller::Web::ApplicationController
  def new
    if receivers_ids_any?
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
    @delivery.public_send(params[:process]) if params[:process].in? %w[run send_to_me]
    case params[:process]
    when 'run'
      redirect_to [benchkiller_web_offers_path, '?', { flash: :success_started_delivery }.to_query].join
    when 'send_to_me'
      redirect_to benchkiller_web_delivery_path(@delivery.uuid)
    end
  end

  private

  def receivers_ids_any?
    params.keys.map { |key| key.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/) }.include? true
  end
end
