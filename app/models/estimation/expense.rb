class Estimation::Expense < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project'
  has_many :costs, class_name: 'Estimation::Cost', as: :associated

  def sum
    price * count
  end
end
