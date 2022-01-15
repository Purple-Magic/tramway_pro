# frozen_string_literal: true

class Benchkiller::Api::OffersController < Benchkiller::Api::ApplicationController
  def index
    params[:collection] ||= :lookfor
    head 406 unless params[:collection].in?(::Benchkiller::Offer::AVAILABLE_SCOPES)

    offers = ::Benchkiller::Offer.public_send(params[:collection])
    offers = Benchkiller::Offers::SearchService.new(params[:search], offers, :query).call
    offers = Benchkiller::Offers::SearchService.new(params[:regions], offers, :regions).call
    offers = Benchkiller::Offers::SearchService.new(
      {
        begin_date: params[:begin_date],
        end_date: params[:end_date]
      },
      offers,
      :period
    ).call
    @full_offers_collection = offers.approved.order(created_at: :desc)

    render json: @full_offers_collection.page(params[:page]),
      each_serializer: ::Benchkiller::OfferSerializer,
      include: '*',
      status: :ok
  end
end
