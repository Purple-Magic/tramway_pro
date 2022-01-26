# frozen_string_literal: true

class Benchkiller::Web::DeliveriesController < Benchkiller::Web::ApplicationController
  def new
    if receivers.any?
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
      @receivers = Benchkiller::Offer.where(uuid: @delivery_form.receivers.split(',')).map(&:benchkiller_user).uniq
      render :new
    end
  end

  def show
    @delivery = ::Benchkiller::DeliveryDecorator.decorate ::Benchkiller::Delivery.find_by uuid: params[:id]
  end

  def edit
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.find_by uuid: params[:id]
    @receivers = Benchkiller::Offer.where(id: @delivery_form.model.receivers_ids).map(&:benchkiller_user).uniq
  end

  def update
    @delivery_form = ::Benchkiller::Web::DeliveryForm.new ::Benchkiller::Delivery.find_by uuid: params[:id]
    if @delivery_form.submit params[:benchkiller_delivery]
      @delivery_form.model.reload
      redirect_to benchkiller_web_delivery_path(@delivery_form.model.uuid)
    else
      @receivers = Benchkiller::Offer.where(id: @delivery_form.model.receivers_ids).map(&:benchkiller_user).uniq
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

  def receivers
    ids = params[:keys]&.split(',')&.map do |key|
      key if key.match?(/^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/)
    end&.compact
    @receivers = Benchkiller::Offer.where(uuid: ids).map(&:benchkiller_user).uniq
  end
end
