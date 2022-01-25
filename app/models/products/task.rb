class Products::Task < ApplicationRecord
  belongs_to :product

  has_many :time_logs, as: :associated
end
