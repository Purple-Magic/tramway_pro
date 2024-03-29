# frozen_string_literal: true

class Admin::Listai::BookForm < Tramway::ApplicationForm
  properties :title

  def initialize(object)
    super(object).tap do
      form_properties title: :string
    end
  end
end
