class Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :product_id, :data, :card_id, :deleted_at

  def project_id=(value)
    model.project_id = 7
    model.save!
  end
end
