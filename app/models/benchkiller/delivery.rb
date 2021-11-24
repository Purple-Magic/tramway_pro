class Benchkiller::Delivery < ApplicationRecord
  belongs_to :user, class_name: 'Benchkiller::User', foreign_key: :benchkiller_user_id
  validates :text, presence: true

  scope :benchkiller_scope, lambda { |_user| all }

  aasm :delivery_state do
    state :ready, initial: true
    state :in_progress
    state :done

    event :run do
      transitions from: :ready, to: :in_progress

      after do
        save!
        ::BenchkillerDeliveryWorker.perform_async receivers_ids, text
      end
    end

    event :finish do
      transitions from: :in_progress, to: :done
    end
  end

  def receivers
    Benchkiller::Offer.where(id: receivers_ids).map(&:message).map(&:user)
  end

  def send_to_me
    ::BenchkillerDeliveryWorker.perform_async [benchkiller_user_id], text
  end
end
