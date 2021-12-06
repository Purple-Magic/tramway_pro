# frozen_string_literal: true

class Estimation::Project::ExpensesXlsDecorator < Tramway::Export::Xls::ApplicationDecorator
  delegate_attributes :title, :count, :description

  class << self
    def columns
      %i[title price count sum description].map do |column|
        { Estimation::Expense.human_attribute_name(column) => column }
      end
    end

    def filename
      'expenses.xls'
    end

    def sheet_name
      'Оценка'
    end
  end

  include Estimation::CoefficientsConcern
  include Estimation::ExpenseConcern

  def price
    price_with_coefficients
  end

  def sum
    sum_with_coefficients
  end
end
