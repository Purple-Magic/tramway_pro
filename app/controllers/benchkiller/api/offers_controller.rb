# frozen_string_literal: true

class Benchkiller::Api::OffersController < Benchkiller::Api::ApplicationController
  def index
    params[:collection] ||= :lookfor
    unless params[:collection].to_sym.in?(::Benchkiller::Offer::AVAILABLE_SCOPES)
      render json: 'Unacceptable collection param',
        status: 406
      return
    end
    if params[:period].present? && !params[:period].in?([ 'all_time', 'day', 'week', 'month', 'quarter' ])
      render json: 'Unacceptable period param',
        status: 406
      return
    end

    search_offers

    render json: @full_offers_collection.page(params[:page]),
      each_serializer: ::Benchkiller::OfferSerializer,
      include: '*',
      status: :ok
  end
end
