# frozen_string_literal: true

class Estimation::Project < ApplicationRecord
  belongs_to :customer, class_name: 'Estimation::Customer'
  belongs_to :associated, polymorphic: true, optional: true
  has_many :tasks, class_name: 'Estimation::Task', foreign_key: :estimation_project_id
  # NOTE: we need this scope for exporting
  has_many :single_tasks, -> { single.order(:id) }, class_name: 'Estimation::Task', foreign_key: :estimation_project_id
  has_many :expenses, class_name: 'Estimation::Expense', foreign_key: :estimation_project_id
  has_many :coefficients, class_name: 'Estimation::Coefficient', foreign_key: :estimation_project_id

  enumerize :associated_type, in: [Course, Product]

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

    event :calc do
      transitions from: %i[estimation_in_progress estimation_done], to: :estimation_in_progress

      after do
        save!

        ::Estimation::Projects::CalcService.new(self).call
      end
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
