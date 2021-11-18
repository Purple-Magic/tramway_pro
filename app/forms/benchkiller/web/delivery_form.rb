class Benchkiller::Web::DeliveryForm < Tramway::Core::ApplicationForm
  properties :text, :receivers_ids, :project_id

  def submit(params)
    params[:project_id] = 7
    params[:receivers_ids] = params[:receivers_ids].split(',').map do |uuid|
      ::Benchkiller::Offer.find_by(uuid: uuid).id
    end
    super.tap do

    end
  end
end
