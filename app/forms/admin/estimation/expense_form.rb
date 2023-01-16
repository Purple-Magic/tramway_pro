# frozen_string_literal: true

class Admin::Estimation::ExpenseForm < Tramway::ApplicationForm
  properties :estimation_project_id, :project_id, :state, :title, :count, :price, :description

  association :estimation_project

  def initialize(object)
    super(object).tap do
      form_properties estimation_project: :association,
        title: :string,
        price: :float,
        count: :float,
        description: :text
    end
  end
end
