# frozen_string_literal: true

class MagicWood::Actors::Photo < ApplicationRecord
  belongs_to :actor, class_name: 'MagicWood::Actor'

  uploader :file, :photo, versions: %i[medium small]
end
