class Products::Task < ApplicationRecord
  belongs_to :product

  has_many :time_logs, class_name: 'TimeLog', as: :associated

end
