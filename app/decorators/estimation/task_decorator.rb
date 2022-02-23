# frozen_string_literal: true

class Estimation::TaskDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :title,
    :hours,
    :price,
    :created_at,
    :updated_at,
    :specialists_count,
    :sum,
    :task_type
  )

  include Estimation::CoefficientsConcern
  include Estimation::RealConcern
  include Estimation::TaskConcern

  def description
    content_tag :span, style: 'font-size: 12px' do
      object.description
    end
  end

  class << self
    def collections
      [:all]
    end

    def list_attributes
      %i[
        id
        title
        hours
        price
      ]
    end

    def show_attributes
      %i[
        id
        title
        hours
        price
        specialists_count
        description
        created_at
        updated_at
      ]
    end

    def show_associations; end

    def list_filters; end
  end
end
