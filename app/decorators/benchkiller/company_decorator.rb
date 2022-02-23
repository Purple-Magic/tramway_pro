# frozen_string_literal: true

class Benchkiller::CompanyDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :title,
    :data,
    :state,
    :created_at,
    :updated_at,
    :portfolio_url,
    :company_url,
    :email,
    :place,
    :phone,
    :regions_to_cooperate,
    :user_is?,
    :uuid
  )

  def bot_card
    <<~TXT
            🏬 Название: #{title}

            🔗 Сайт: #{company_url}

            🎨 Портфолио: #{portfolio_url}

            📧 Почта: #{email}

            📞 Телефон: #{phone}

            🌉 Регион: #{place}
            
            🌎 Регион работы: #{regions_to_cooperate}
    TXT
  end

  def review_state
    state_machine_view object, :review_state
  end

  def users
    content_tag(:table) do
      object.users.each do |user|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat(user.id)
          end)
          concat(content_tag(:td) do
            link_to user.username, Tramway::Admin::Engine.routes.url_helpers.record_path(user.id, model: user.class)
          end)
        end)
      end
    end
  end

  def data_view
    content_tag(:table) do
      %i[email phone company_url portfolio_url place regions_to_cooperate].each do |attribute|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            object.class.human_attribute_name attribute
          end)
          concat(content_tag(:td) do
            data_view_mode attribute, data&.dig(attribute.to_s)
          end)
        end)
      end
    end
  end

  def review_state_button_color(event)
    { approve: :success, decline: :danger, return_to_unviewed: :warning }[event]
  end

  class << self
    def collections
      %i[all unviewed approved declined]
    end

    def list_attributes
      %i[
        data_view
        review_state
      ]
    end

    def show_attributes
      %i[
        id
        title
        data_view
        created_at
        updated_at
        users
      ]
    end

    def show_associations
      []
    end

    def list_filters; end
  end

  private

  def data_view_mode(key, value)
    if key.in? [:email]
      mail_to value if value.present?
    elsif key.in? [:phone]
      link_to value, "tel:#{value}" if value.present?
    elsif key.in? %i[company_url portfolio_url]
      link_to value.truncate(60), value, target: '_blank' if value.present?
    else
      value
    end
  end
end
