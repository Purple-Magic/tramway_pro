class Product < ApplicationRecord
  has_many :tasks, class_name: 'Products::Task', dependent: :destroy
  has_many :time_logs, through: :tasks
end
