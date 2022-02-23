# frozen_string_literal: true

class Products::Task < ApplicationRecord
  belongs_to :product, class_name: 'Product'

  has_many :time_logs, class_name: 'TimeLog', as: :associated

  include TimeManager

  def estimated_minutes
    minutes_of estimation
  end
end
