class Benchkiller::Company < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :users, through: :companies_users, class_name: 'Benchkiller::User'

  store_accessor :data, :portfolio_url
  store_accessor :data, :company_url
  store_accessor :data, :email
  store_accessor :data, :place
  store_accessor :data, :phone
  store_accessor :data, :regions_to_cooperate

  scope :benchkiller_scope, lambda { |_user| all }

  validates :title, uniqueness: true, if: -> { state == 'active' }

  search_by :title

  aasm :review_state do
    state :unviewed, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :unviewed, to: :approved
    end

    event :decline do
      transitions from: :unviewed, to: :declined
    end

    event :return_to_unviewed do
      transitions from: [ :approved, :declined ], to: :unviewed
    end
  end
end
