# frozen_string_literal: true

class Benchkiller::Offer < ApplicationRecord
  belongs_to :message, class_name: 'BotTelegram::Message'
  has_and_belongs_to_many :tags, class_name: 'Benchkiller::Tag'

  scope :benchkiller_scope, ->(_user) { all }
  scope :approved, -> { where approval_state: :approved }
  scope :declined, -> { where approval_state: :declined }
  scope :unviewed, -> { where approval_state: :unviewed }

  AVAILABLE_SCOPES = %i[lookfor available].freeze
  AVAILABLE_SCOPES.each do |scope_name|
    scope scope_name, lambda {
      ::Benchkiller::Tag.includes(:offers).find_by(title: scope_name).offers
    }
  end

  search_by message: [:text]

  aasm :approval_state do
    state :unviewed, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :unviewed, to: :approved

      after do
        save!
        send_to_public_channel
      end
    end

    event :decline do
      transitions from: :unviewed, to: :declined
    end
  end

  def send_to_public_channel
    channel = if available?
                ::BotTelegram::BenchkillerBot::FREE_DEV_CHANNEL
              elsif lookfor?
                ::BotTelegram::BenchkillerBot::NEED_DEV_CHANNEL
              end
    ::Benchkiller::SendOfferToPublicChannelWorker.new.perform id, channel
  end

  def available?
    collation = ::Benchkiller::Collation.full_text_search(:available).first
    tags.each do |tag|
      return true if collation.all_words.include? tag.title
    end
    false
  end

  def lookfor?
    collation = ::Benchkiller::Collation.full_text_search(:lookfor).first
    tags.each do |tag|
      return true if collation.all_words.include? tag.title
    end
    false
  end

  def parse!
    parsed_tags = message.text.scan(/\#[0-9a-zA-Zа-яА-Я]+/)
    parsed_tags&.each do |tag|
      tag_obj = Benchkiller::Tag.find_or_create_by! title: tag.to_s.gsub('#', '').downcase, project_id: 7
      tags << tag_obj
      save!
    end
  end

  def company
    user = Benchkiller::User.find_by bot_telegram_user_id: message.user.id
    user.company if user.present?
  end

  def benchkiller_user
    Benchkiller::User.find_by(bot_telegram_user_id: message.user.id) if message.user.present?
  end
end
