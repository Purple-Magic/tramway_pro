# frozen_string_literal: true

class Admin::MagicWood::Actors::PhotoForm < Tramway::ApplicationForm
  properties :project_id, :state, :file

  association :actor

  def initialize(object)
    super(object).tap do
      form_properties actor: :association,
        file: :file
    end
  end
end
