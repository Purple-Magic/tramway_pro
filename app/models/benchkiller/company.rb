class Benchkiller::Company < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :users, through: :companies_users
end
