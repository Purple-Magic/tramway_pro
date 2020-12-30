class Estimation::Customer < ApplicationRecord
  has_many :projects, class_name: 'Estimation::Project'
end
