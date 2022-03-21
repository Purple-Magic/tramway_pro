# frozen_string_literal: true

module Benchkiller::Concerns
  def search_offers
    offers = ::Benchkiller::Offer.public_send(params[:collection])
    offers = Benchkiller::Offers::SearchService.new(params[:search], offers, :query).call
    offers = Benchkiller::Offers::SearchService.new(params[:regions], offers, :regions).call
    offers = Benchkiller::Offers::SearchService.new(
      {
        period: params[:period],
        begin_date: params[:begin_date],
        end_date: params[:end_date]
      },
      offers,
      :period
    ).call

    if params[:search].present?
      offers = Benchkiller::Offer.includes(message: :user).where id: offers.map(&:id)
      offers_ids = offers.reverse.uniq { |offer| offer.message.user.id }.reverse.map &:id
      offers = Benchkiller::Offer.where id: offers_ids
    end

    @full_offers_collection = offers.approved.order(created_at: :desc)
  end

  REGIONS_DICTIONARY = {
    'Россия' => ['РФ', 'Российская федерация', 'Russia'],
    'Беларусь' => ['Республика Беларусь', 'РБ', 'Беларуссия', 'Белоруссия', 'Belarus', 'Белорусь', 'Belarussia'],
    'Украина' => %w[Ukraine UA],
    'Грузия' => ['Georgia'],
    'США' => ['USA'],
    'Азербайджан' => ['Azerbaijan'],
    'Великобритания' => ['Британия'],
    'Все регионы' => %w[Worldwide Все]
  }.freeze
end
