class Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :product, :data, :card_id, :deleted_at

  def product=(value)
    model.product_id = Product.find_by(tech_name: value, project_id: 7).id 
    model.save!
  end

  def project_id=(value)
    model.project_id = 7
    model.save!
  end
end
