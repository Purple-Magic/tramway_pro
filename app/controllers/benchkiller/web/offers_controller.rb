class Benchkiller::Web::OffersController < Benchkiller::Web::ApplicationController
  def index
    params[:collection] ||= :look_for
    if params[:collection] == 'all'
      @offers = ::Benchkiller::OfferDecorator.decorate ::Benchkiller::Offer.active.page params[:page]
    else
      offers_ids = ::Benchkiller::Tag.active.includes(:offers).find_by(title: params[:collection]).offers.map &:id
      @offers = ::Benchkiller::OfferDecorator.decorate ::Benchkiller::Offer.where(id: offers_ids).page params[:page]
    end
  end
end
