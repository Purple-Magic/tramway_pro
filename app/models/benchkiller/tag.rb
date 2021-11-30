# frozen_string_literal: true

class Benchkiller::Tag < ApplicationRecord
  has_and_belongs_to_many :offers, class_name: 'Benchkiller::Offer'

  scope :benchkiller_scope, ->(_user) { all }

  validates :title, uniqueness: true

  search_by :title
end
