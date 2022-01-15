# frozen_string_literal: true

class Benchkiller::Api::OffersController < Benchkiller::Api::ApplicationController
  def index
    params[:collection] ||= :lookfor
    if params[:collection].in?(::Benchkiller::Offer::AVAILABLE_SCOPES)
      offers = ::Benchkiller::Offer.public_send(params[:collection])
      offers = Benchkiller::Offers::SearchService.new(
        argument: params[:search],
        current_collection: offers,
        search_type: :query
      ).call
      offers = Benchkiller::Offers::SearchService.new(
        argument: params[:regions],
        current_collection: offers,
        search_type: :regions
      ).call
      offers = Benchkiller::Offers::SearchService.new(
        argument: {
          begin_date: params[:begin_date],
          end_date: params[:end_date]
        },
        current_collection: offers,
        search_type: :period
      ).call
      @full_offers_collection = offers.approved.order(created_at: :desc)

      render json: @full_offers_collection.page(params[:page]),
        each_serializer: ::Benchkiller::OfferSerializer,
        include: '*',
        status: :ok
    else
      head 406
    end
  end
end
