# frozen_string_literal: true

module Benchkiller::RegionsConcern
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
