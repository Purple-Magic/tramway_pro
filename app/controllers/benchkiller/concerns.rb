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
  
  def regions
    regions = ::Benchkiller::Company.approved.map do |company|
      company.regions_to_cooperate if company.regions_to_cooperate.is_a? Array
    end.flatten.compact.uniq
    filtered_array = regions.map do |region|
      if REGIONS_DICTIONARY.include? region
        region
      else
        REGIONS_DICTIONARY.map do |(key, value)|
          key if value.include? region
        end.compact.first || region
      end
    end.compact.uniq
    regions_at_the_beginning = ['Все регионы', 'СНГ', 'Европа', 'Азия']
    regions_at_the_beginning + (filtered_array - regions_at_the_beginning).sort
  end
end
