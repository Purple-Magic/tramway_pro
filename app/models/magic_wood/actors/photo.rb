class MagicWood::Actors::Photo < ApplicationRecord
  belongs_to :actor, class_name: 'MagicWood::Actor'

  uploader :file, :photo, versions: [ :medium, :small ]
end
