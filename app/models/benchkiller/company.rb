class Benchkiller::Company < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :users, through: :companies_users

  store_accessor :data, :portfolio_url
  store_accessor :data, :company_url
  store_accessor :data, :email
  store_accessor :data, :place
  store_accessor :data, :phone
  store_accessor :data, :regions_to_cooperate

  scope :benchkiller_scope, lambda { |_user| all }
end
