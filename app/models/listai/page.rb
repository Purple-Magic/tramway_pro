# frozen_string_literal: true

class Listai::Page < ApplicationRecord
  belongs_to :book, class_name: 'Listai::Book'

  mount_uploader :file, PhotoUploader
end
