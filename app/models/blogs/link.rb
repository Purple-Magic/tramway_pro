# frozen_string_literal: true

class Blogs::Link < ApplicationRecord
  enumerize :link_type, in: %i[article video]

  uploader :image, :photo
end
