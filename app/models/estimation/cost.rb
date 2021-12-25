# frozen_string_literal: true

class Estimation::Cost < ApplicationRecord
  belongs_to :associated, polymorphic: true

  enumerize :associated_type, in: ['Estimation::Task', 'Estimation::Expense']
end
