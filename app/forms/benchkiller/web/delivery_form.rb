class Benchkiller::Web::DeliveryForm < Tramway::Core::ApplicationForm
  properties :text, :receivers_ids, :project_id, :benchkiller_user_id
  attr_accessor :receivers

  def submit(params)
    params[:project_id] = 7
    params[:receivers_ids] = params[:receivers].split(',').map do |uuid|
      ::Benchkiller::Offer.find_by(uuid: uuid).id
    end

    super
  end
end
