class Benchkiller::Web::OffersController < Benchkiller::Web::ApplicationController
  def index
    @offers = ::Benchkiller::OfferDecorator.decorate ::Benchkiller::Offer.active.page params[:page]
  end
end
