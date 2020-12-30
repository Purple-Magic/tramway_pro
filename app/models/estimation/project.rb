class Estimation::Project < ApplicationRecord
  belongs_to :customer, class_name: 'Estimation::Customer'
  has_many :tasks, class_name: 'Estimation::Task', foreign_key: :estimation_project_id

  validates :title, presence: true
end
