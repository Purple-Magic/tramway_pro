class Benchkiller::Web::DeliveryForm < Tramway::Core::ApplicationForm
  properties :text, :receivers_ids, :project_id
  attr_accessor :receivers

  def submit(params)
    params[:project_id] = 7
    params[:receivers_ids] = params[:receivers].split(',').map do |uuid|
      ::Benchkiller::Offer.find_by(uuid: uuid).id
    end
    super.tap do |result|
      if result && model.text.present?
        ::BenchkillerDeliveryWorker.perform_async model.receivers_ids, model.text
      end
    end
  end
end
