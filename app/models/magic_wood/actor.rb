class MagicWood::Actor < ApplicationRecord
  has_many :photos, class_name: 'MagicWood::Actors::Photo'
  has_many :attendings, class_name: 'MagicWood::Actors::Attending'
end
