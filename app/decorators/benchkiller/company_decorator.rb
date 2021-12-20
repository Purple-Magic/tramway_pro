# frozen_string_literal: true

class Benchkiller::CompanyDecorator < Tramway::Core::ApplicationDecorator
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
    :has_user?,
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
      data&.each do |pair|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            object.class.human_attribute_name pair[0]
          end)
          concat(content_tag(:td) do
            data_view_mode pair
          end)
        end)
      end
    end
  end

  def review_state_button_color(event)
    case event
    when :approve
      :success
    when :decline
      :danger
    when :return_to_unviewed
      :warning
    end
  end

  class << self
    def collections
      [:unviewed, :approved, :declined, :all]
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

    def list_filters
    end
  end

  private

  def data_view_mode(pair)
    if pair[0].in? ['email']
      mail_to pair[1]
    elsif pair[0].in? ['phone']
      link_to pair[1], "tel:#{pair[1]}"
    elsif pair[0].in? %w[company_url portfolio_url]
      link_to pair[1].truncate(60), pair[1], target: '_blank'
    else
      pair[1]
    end
  end
end
