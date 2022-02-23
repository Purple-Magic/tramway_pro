# frozen_string_literal: true

class Estimation::Task < ApplicationRecord
  belongs_to :estimation_project, class_name: 'Estimation::Project', foreign_key: :estimation_project_id
  has_many :costs, class_name: 'Estimation::Cost', as: :associated

  enumerize :task_type, in: %i[single multiple], default: :single

  scope :single, -> { where task_type: :single }
  scope :multiple, -> { where task_type: :multiple }

  validates :title, presence: true
  validates :hours, presence: true
  validates :price, presence: true

  def sum
    hours * price * specialists_count
  end
end
