class Product < ApplicationRecord
  has_many :tasks, -> { order :id }, class_name: 'Products::Task', dependent: :destroy
  has_many :time_logs, through: :tasks, class_name: 'TimeLog'
end
