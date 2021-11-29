class Benchkiller::Web::OffersController < Benchkiller::Web::ApplicationController
  def index
    params[:collection] ||= :lookfor
    offers_ids = if params[:collection] == 'all'
      ::Benchkiller::Offer.active.map(&:id)
    else
      ::Benchkiller::Tag.active.includes(:offers).find_by(title: params[:collection]).offers.map(&:id)
    end
    offers = ::Benchkiller::Offer.where(id: offers_ids)
    if params[:search].present?
      collation = ::Benchkiller::Collation.full_text_search(params[:search]).first
      if collation.present?
        offers_ids = collation.all_words.map do |word|
          offers.full_text_search word
        end.flatten.uniq.map(&:id)
        offers = ::Benchkiller::Offer.where id: offers_ids
      else
        offers = offers.full_text_search params[:search]
      end
    end
    @offers = ::Benchkiller::OfferDecorator.decorate offers.approved.page params[:page]
  end
end
