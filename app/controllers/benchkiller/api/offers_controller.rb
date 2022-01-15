# frozen_string_literal: true

class Benchkiller::Api::OffersController < Benchkiller::Api::ApplicationController
  def index
    params[:collection] ||= :lookfor
    head 406 unless params[:collection].in?(::Benchkiller::Offer::AVAILABLE_SCOPES)

    search_offers

    render json: @full_offers_collection.page(params[:page]),
      each_serializer: ::Benchkiller::OfferSerializer,
      include: '*',
      status: :ok
  end
end
