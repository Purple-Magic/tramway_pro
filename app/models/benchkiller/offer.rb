class Benchkiller::Offer < ApplicationRecord
  belongs_to :message, class_name: 'BotTelegram::Message'
  has_and_belongs_to_many :tags, class_name: 'Benchkiller::Tag'

  scope :benchkiller_scope, lambda { |_user| all }

  search_by message: [ :text ]

  aasm :approval_state do
    state :unviewed, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :unviewed, to: :approved

      after do
        save!
        channel = if available?
                    ::BotTelegram::BenchkillerBot::FREE_DEV_CHANNEL
                  elsif lookfor?
                    ::BotTelegram::BenchkillerBot::NEED_DEV_CHANNEL
                  end
        ::BenchkillerSendOfferToPublicChannelWorker.new.perform id, channel
      end
    end

    event :decline do
      transitions from: :unviewed, to: :declined
    end
  end

  def available?
    collation = ::Benchkiller::Collation.full_text_search(:available).first
    tags.each do |tag|
      return true if collation.all_words.include? tag.title      
    end
    return false
  end

  def lookfor?
    collation = ::Benchkiller::Collation.full_text_search(:lookfor).first
    tags.each do |tag|
      return true if collation.all_words.include? tag.title      
    end
    return false
  end

  def parse!
    parsed_tags = message.text.scan(/\#[0-9a-zA-Zа-яА-Я]+/)
    parsed_tags&.each do |tag|
      tag_obj = Benchkiller::Tag.find_or_create_by! title: tag.to_s.gsub('#', '').downcase, project_id: 7
      tags << tag_obj
      save!
    end
  end
end
