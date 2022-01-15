# frozen_string_literal: true

class Benchkiller::Offers::SearchService
  attr_reader :argument, :current_collection, :search_type

  def initialize(argument:, current_collection:, search_type:)
    @argument = argument
    @current_collection = current_collection
    @search_type = search_type
  end

  def call
    if send "condition_to_#{search_type}_search?"
      send "#{search_type}_search"
    else
      current_collection
    end
  end

  private

  def condition_to_query_search?
    argument.present?
  end

  def query_search
    collation = ::Benchkiller::Collation.full_text_search(argument).first
    if collation.present?
      offers_ids = collation.all_words.map do |word|
        current_collection.full_text_search word
      end.flatten.uniq.map(&:id)
      ::Benchkiller::Offer.where id: offers_ids
    else
      current_collection.full_text_search argument
    end
  end

  def condition_to_regions_search?
    argument.present? && argument != 'Все регионы'
  end

  def regions_search
    companies = ::Benchkiller::Company.map do |company|
      company if company.regions_to_cooperate&.include? argument
    end.compact
    users_ids = companies.map(&:users).flatten.map(&:telegram_user).map(&:id)
    offers_ids = current_collection.map do |offer|
      offer if offer.message.user_id.in? users_ids
    end
    ::Benchkiller::Offer.where id: offers_ids
  end

  def condition_to_period_search?
    argument[:begin_date].present? && argument[:end_date].present?
  end

  def period_search
    current_collection.where 'created_at > ? AND created_at < ?', argument[:begin_date].to_date,
      argument[:end_date].to_date
  end
end
