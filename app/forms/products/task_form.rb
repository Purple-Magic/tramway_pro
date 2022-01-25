class Products::TaskForm < Tramway::Core::ApplicationForm
  properties :title, :project_id, :product, :data

  def product=(value)
    model.product_id = Product.find_by(title: value).id 
    model.save!
  end

  def project_id=(value)
    model.project_id = 7
    model.save!
  end
end
