# frozen_string_literal: true

class Benchkiller::Company < ApplicationRecord
  has_many :companies_users, class_name: 'Benchkiller::CompaniesUser'
  has_many :users, through: :companies_users, class_name: 'Benchkiller::User'

  store_accessor :data, :portfolio_url
  store_accessor :data, :company_url
  store_accessor :data, :email
  store_accessor :data, :place
  store_accessor :data, :phone
  store_accessor :data, :regions_to_cooperate

  scope :benchkiller_scope, ->(_user) { all }

  validates :title, uniqueness: true
  validates :company_url, url: true
  validates :email, email: true
  validates :portfolio_url, url: true

  search_by :title

  aasm :review_state do
    state :unviewed, initial: true
    state :approved
    state :declined

    event :approve do
      transitions from: :unviewed, to: :approved

      after do
        save!
        user = users.first
        BenchkillerSendApprovementMessageWorker.perform_async user.id
      end
    end

    event :decline do
      transitions from: :unviewed, to: :declined
    end

    event :return_to_unviewed do
      transitions from: %i[approved declined], to: :unviewed
    end
  end

  def has_user?(user)
    users.include? user
  end
end
