class Estimation::Expense < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project'

  def sum
    price * count
  end
end
