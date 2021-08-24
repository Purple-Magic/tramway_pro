# frozen_string_literal: true

class TimeLog < ApplicationRecord
  belongs_to :associated, polymorphic: true

  enumerize :associated_type, in: [ Courses::Video ]
end
