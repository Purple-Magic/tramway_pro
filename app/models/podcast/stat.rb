# frozen_string_literal: true

class Podcast::Stat < ApplicationRecord
  belongs_to :podcast

  enumerize :service, in: %i[yandex google youtube redcircle apple spotify]

  scope :for, proc { |month, year| where month: month, year: year }
end
