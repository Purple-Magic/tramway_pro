# frozen_string_literal: true

class TimeLogDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :associated_type,
    :associated_id,
    :time_spent,
    :comment,
    :created_at,
    :updated_at
  )

  decorate_association :associated
  decorate_association :user

  def title
    "#{user.title} | #{associated.title} - #{object.created_at.strftime('%d.%m.%Y')}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      %i[
        id
        associated_type
        associated_id
        time_spent
      ]
    end

    def show_attributes
      %i[
        id
        associated_type
        associated_id
        time_spent
        comment
        created_at
        updated_at
      ]
    end

    def show_associations
      # Associations you want to show in admin dashboard
      # [ :messages ]
    end

    def list_filters
      # {
      #   date: {
      #     type: :dates,
      #     query: lambda do |list, begin_date, end_date|
      #       list.where 'created_at > ? AND created_at < ?', begin_date, end_date
      #     end
      #   }
      # }
    end
  end
end
