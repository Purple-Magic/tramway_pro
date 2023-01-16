# frozen_string_literal: true

class Admin::PurpleMagicForm < Tramway::ApplicationForm
  properties :favicon

  def initialize(object)
    super(object).tap do
      form_properties favicon: :file
    end
  end
end
