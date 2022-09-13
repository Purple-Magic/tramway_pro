class Blogs::Link < ApplicationRecord
  enumerize :link_type, in: [ :article, :video ]

  uploader :image, :photo
end
