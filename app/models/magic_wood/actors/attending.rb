class MagicWood::Actors::Attending < ApplicationRecord
  belongs_to :actor, class_name: 'MagicWood::Actor'
  belongs_to :estimation_project, class_name: 'Estimation::Project'
end
