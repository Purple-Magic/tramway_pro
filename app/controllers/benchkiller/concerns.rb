# frozen_string_literal: true

module Benchkiller::Concerns
  def search_offers
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
  end
end
