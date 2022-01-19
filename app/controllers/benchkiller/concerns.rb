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
    @full_offers_collection = offers.approved.order(created_at: :desc)
  end

  def regions
    regions = ::Benchkiller::Company.approved.map do |company|
      company.regions_to_cooperate if company.regions_to_cooperate.is_a? Array
    end.flatten.compact.uniq
    regions_dictionary = {
      'Россия' => ['РФ', 'Российская федерация', 'Russia'],
      'Беларусь' => ['Республика Беларусь', 'РБ', 'Беларуссия', 'Belarus', 'Белорусь', 'Belarussia'],
      'Украина' => %w[Ukraine UA],
      'Грузия' => ['Georgia'],
      'США' => ['USA'],
      'Азербайджан' => ['Azerbaijan'],
      'Все регионы' => %w[Worldwide Все]
    }
    regions.map do |region|
      if regions_dictionary.include? region
        region
      else
        regions_dictionary.map do |pair|
          pair[0] if pair[1].include? region
        end.compact.first || region
      end
    end.compact.uniq
  end
end
