class Estimation::Task < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project', foreign_key: :estimation_project_id

  validates :title, presence: true
  validates :hours, presence: true
  validates :price, presence: true
end
