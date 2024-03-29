# frozen_string_literal: true

class Products::TaskSerializer < ApplicationSerializer
  attributes :title, :internal_id

  def internal_id
    object.id
  end
end
