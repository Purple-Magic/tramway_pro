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
        ::Benchkiller::DeliveryWorker.new.perform receivers.map(&:id), final_text
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
    text_with_test_message = "Ответ на ваш запрос от @#{user.username} "
    text_with_test_message += "и #{user.company.title}" if user.company&.title.present?
    text_with_test_message += "\n\n"
    text_with_test_message + "#{text}\n\nЭта рассылка делается в тестовом режиме. Если у вас есть вопросы или предложения по этим рассылкам, напишите @Egurt73, Benchkiller"
  end
end
