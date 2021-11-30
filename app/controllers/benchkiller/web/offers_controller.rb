# frozen_string_literal: true

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
    if params[:regions].present?
      companies = ::Benchkiller::Company.active.map do |company|
        company if company.regions_to_cooperate&.include? params[:regions]
      end.compact
      users_ids = companies.map(&:users).flatten.map(&:telegram_user).map(&:id)
      offers_ids = offers.map do |offer|
        offer if offer.message.user_id.in? users_ids
      end
      offers = ::Benchkiller::Offer.where id: offers_ids
    end
    offers = offers.where 'created_at > ?', params[:begin_date].to_date if params[:begin_date].present?
    offers = offers.where 'created_at < ?', params[:end_date].to_date if params[:end_date].present?
    @full_offers_collection = offers.approved
    @offers = ::Benchkiller::OfferDecorator.decorate @full_offers_collection.page params[:page]
  end
end
