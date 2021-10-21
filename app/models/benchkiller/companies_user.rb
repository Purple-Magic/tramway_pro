class Benchkiller::CompaniesUser < ApplicationRecord
  belongs_to :user, class_name: 'Benchkiller::User'
  belongs_to :company, class_name: 'Benchkiller::Company'
end
