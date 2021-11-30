# frozen_string_literal: true

class Benchkiller::CompaniesUser < ApplicationRecord
  belongs_to :user, class_name: 'Benchkiller::User'
  belongs_to :company, class_name: 'Benchkiller::Company'

  scope :benchkiller_scope, ->(_user) { all }
end
