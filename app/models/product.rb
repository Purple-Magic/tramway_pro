# frozen_string_literal: true

class Product < ApplicationRecord
  has_many :tasks, -> { order :id }, class_name: 'Products::Task', dependent: :destroy
  has_many :time_logs, through: :tasks, class_name: 'TimeLog'

  aasm column: :product_state do
    state :in_progress, initial: true
    state :finished

    event :finish do
      transitions from: :in_progress, to: :finished
    end
  end
end
