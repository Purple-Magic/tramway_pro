class Benchkiller::Notification < ApplicationRecord
  scope :benchkiller_scope, lambda { |_user| all }
end
