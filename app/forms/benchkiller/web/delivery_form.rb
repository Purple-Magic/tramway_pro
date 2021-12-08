# frozen_string_literal: true

class Benchkiller::Web::DeliveryForm < Tramway::Core::ApplicationForm
  properties :text, :receivers_ids, :project_id, :benchkiller_user_id
  attr_accessor :receivers

  def submit(params)
    if params[:receivers].present?
      params[:project_id] = 7
      params[:receivers_ids] = params[:receivers].split(',').map do |uuid|
        ::Benchkiller::Offer.find_by(uuid: uuid).id
      end
    end

    super
  end
end
