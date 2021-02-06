class Estimation::Project < ApplicationRecord
  belongs_to :customer, class_name: 'Estimation::Customer'
  has_many :tasks, class_name: 'Estimation::Task', foreign_key: :estimation_project_id
  has_many :coefficients, class_name: 'Estimation::Coefficient', foreign_key: :estimation_project_id

  validates :title, presence: true

  aasm :project_state, column: :project_state do
    state :estimation_in_progress, initial: true
    state :estimation_done
    state :estimation_sent
    state :confirmed
    state :declined

    event :finish_estimation do
      transitions from: :estimation_in_progress, to: :estimation_done
    end

    event :send_to_customer do
      transitions from: :estimation_done, to: :estimation_sent
    end

    event :confirmed_by_customer do
      transitions from: :estimation_sent, to: :confirmed
    end

    event :decline do
      transitions from: :estimation_sent, to: :declined
    end
  end
end
