module Estimation::Project::ExpensesTable
  def expenses_table
    content_tag(:table) do
      expenses_table_header
      expenses_table_body
    end
  end

  EXPENSES_TABLE_COLUMNS = %i[title price count price_with_coefficients description sum sum_with_coefficients].freeze

  def expenses_table_header
    concat(content_tag(:thead) do
      EXPENSES_TABLE_COLUMNS.each do |attribute|
        concat(content_tag(:th) do
          concat(content_tag(:span, style: 'font-size: 10pt') do
            Estimation::Expense.human_attribute_name(attribute)
          end)
        end)
      end
    end)
  end

  def expenses_table_body
    expenses.each do |expense|
      concat(content_tag(:tr) do
        EXPENSES_TABLE_COLUMNS.each do |attribute|
          concat(content_tag(:td) do
            concat expense.send(attribute)
          end)
        end
      end)
    end
  end
end
