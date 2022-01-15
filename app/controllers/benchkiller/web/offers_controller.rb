# frozen_string_literal: true

class Benchkiller::Web::OffersController < Benchkiller::Web::ApplicationController
  def index
    params[:collection] ||= :lookfor

    search_offers

    @offers = ::Benchkiller::OfferDecorator.decorate @full_offers_collection.page params[:page]
    @text = case params[:collection]
            when 'lookfor'
              'Ниже отображаются посты, в которых участники сообщества ищут разработчиков на свои проекты'
            when 'available'
              'Ниже отображаются посты, в которых участники сообщества предлагают своих разработчиков'
            end
  end
end
