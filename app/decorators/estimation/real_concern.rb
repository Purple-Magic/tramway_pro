# frozen_string_literal: true

module Estimation::RealConcern
  def real_sum
    if object.costs.any?
      object.costs.first.price
    else
      sum
    end
  end

  def cost_path
    if object.costs.any?
      Tramway::Admin::Engine.routes.url_helpers.edit_record_path(
        model: Estimation::Cost,
        id: object.costs.first.id,
        redirect: "/admin/records/#{object.estimation_project.id}?model=Estimation::Project"
      )
    else
      Tramway::Admin::Engine.routes.url_helpers.new_record_path(
        model: Estimation::Cost,
        'estimation/cost' => {
          associated: id,
          associated_type: object.class.to_s,
          price: sum
        },
        redirect: "/admin/records/#{object.estimation_project.id}?model=Estimation::Project"
      )
    end
  end
end
