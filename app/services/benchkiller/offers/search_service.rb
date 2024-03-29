# frozen_string_literal: true

class Benchkiller::Offers::SearchService
  attr_reader :argument, :current_collection, :search_type

  def initialize(argument, current_collection, search_type)
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
      if argument.match('\W').present?
        current_collection.joins(:message).where 'bot_telegram_messages.text ILIKE ?', "%#{argument}%"
      else
        current_collection.full_text_search argument
      end
    end
  end

  def condition_to_regions_search?
    argument.present? && argument != 'Все регионы'
  end

  def regions_search
    companies = companies_by region: argument
    users_ids = companies.map(&:users).flatten.map(&:telegram_user).map(&:id)
    offers_ids = current_collection.map do |offer|
      offer if offer.message.user_id.in? users_ids
    end.compact
    ::Benchkiller::Offer.where id: offers_ids
  end

  def companies_by(region:)
    ::Benchkiller::Company.all.map do |company|
      company if company.regions_to_cooperate&.include? region
    end.compact
  end

  def condition_to_period_search?
    argument[:period].present? || (argument[:begin_date].present? && argument[:end_date].present?)
  end

  def period_search
    if argument[:period]
      argument[:end_date] = DateTime.now
      case argument[:period]
      when 'all_time'
        argument[:begin_date] = DateTime.new(2015, 1, 1)
      when 'day'
        argument[:begin_date] = 1.day.ago
      when 'week'
        argument[:begin_date] = 1.week.ago
      when 'month'
        argument[:begin_date] = 1.month.ago
      when 'quarter'
        argument[:begin_date] = 3.months.ago
      end
    end

    current_collection.where(
      'benchkiller_offers.created_at > ? AND benchkiller_offers.created_at < ?',
      argument[:begin_date].to_datetime,
      argument[:end_date].to_datetime
    )
  end
end
