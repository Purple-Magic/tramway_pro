# frozen_string_literal: true

class Listai::Book < ApplicationRecord
  has_many :pages, class_name: 'Listai::Page'
end
