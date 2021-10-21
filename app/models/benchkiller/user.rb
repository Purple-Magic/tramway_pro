class Benchkiller::User < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :companies, through: :companies_users
end
