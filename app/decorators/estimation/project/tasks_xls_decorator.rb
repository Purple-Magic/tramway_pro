# frozen_string_literal: true

class Estimation::Project::TasksXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :title, :hours, :specialists_count, :description

  class << self
    def columns
      %i[title hours price specialists_count sum description].map do |column|
        { Estimation::Task.human_attribute_name(column) => column }
      end
    end

    def filename
      'tasks.xls'
    end

    def sheet_name
      'Оценка'
    end
  end

  include Estimation::CoefficientsConcern
  include Estimation::TaskConcern

  def price
    price_with_coefficients
  end

  def sum
    sum_with_coefficients
  end
end
