# frozen_string_literal: true

class Products::TaskForm < Tramway::ApplicationForm
  properties :title, :project_id, :product_id, :data, :card_id, :deleted_at

  def project_id=(_value)
    model.project_id = 7
    model.save!
  end
end
