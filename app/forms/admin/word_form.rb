# frozen_string_literal: true

class Admin::WordForm < Tramway::Core::ApplicationForm
  properties :main, :synonims, :description, :project_id

  def initialize(obj)
    super(obj).tap do
      form_properties main: :string,
                      synonims: :string,
                      description: :text
    end
  end

  def synonims=(value)
    super value.split(',')
  end
end
