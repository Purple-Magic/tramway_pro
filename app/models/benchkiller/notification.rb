# frozen_string_literal: true

class Benchkiller::Notification < ApplicationRecord
  scope :benchkiller_scope, ->(_user) { all }
end
