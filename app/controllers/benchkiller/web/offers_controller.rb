class Benchkiller::Web::OffersController < Benchkiller::Web::ApplicationController
  def index
    params[:collection] ||= :look_for
    offers_ids = if params[:collection] == 'all'
      ::Benchkiller::Offer.active.map(&:id)
    else
      ::Benchkiller::Tag.active.includes(:offers).find_by(title: params[:collection]).offers.map(&:id)
    end
    offers = ::Benchkiller::Offer.where(id: offers_ids)
    if params[:search].present?
      offers = offers.full_text_search params[:search]
    end
    @offers = ::Benchkiller::OfferDecorator.decorate offers.page params[:page]
  end
end
