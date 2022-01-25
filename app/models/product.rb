class Product < ApplicationRecord
  has_many :tasks, class_name: 'Products::Task'
end
