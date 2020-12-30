class Estimation::Coefficient < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project'
end
