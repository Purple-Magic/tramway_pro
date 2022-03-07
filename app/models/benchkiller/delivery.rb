# frozen_string_literal: true

class Benchkiller::Delivery < ApplicationRecord
  belongs_to :user, class_name: 'Benchkiller::User', foreign_key: :benchkiller_user_id
  validates :text, presence: true

  scope :benchkiller_scope, ->(_user) { all }

  aasm :delivery_state do
    state :ready, initial: true
    state :in_progress
    state :done

    event :run do
      transitions from: :ready, to: :in_progress

      after do
        save!
        ::Benchkiller::DeliveryWorker.perform_async receivers.map(&:id), final_text
      end
    end

    event :finish do
      transitions from: :in_progress, to: :done
    end
  end

  def receivers
    Benchkiller::Offer.where(id: receivers_ids).map(&:message).map(&:user).uniq
  end

  def send_to_me
    ::Benchkiller::DeliveryWorker.new.perform [user.bot_telegram_user_id], final_text
  end

  def final_text
    I18n.t 'benchkiller.bot.deliveries.template',
      username: user.username,
      company: user.company&.title.present? ? "и #{user.company.title}" : '',
      text: text
  end
end
