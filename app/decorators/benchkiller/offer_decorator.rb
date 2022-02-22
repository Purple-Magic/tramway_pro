# frozen_string_literal: true

class Benchkiller::OfferDecorator < ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
    :id,
    :message_id,
    :state,
    :project_id,
    :created_at,
    :updated_at,
    :uuid,
    :company
  )

  decorate_associations :tags
  decorate_association :message

  def title
    user = object.message.user
    user_title = "#{user.username.present? ? user.username : 'No username'}: #{user.first_name} #{user.last_name}"
    "#{user_title}: #{object.message.text&.first(15)...}"
  end

  def tags_list
    content_tag(:ul) do
      tags.each do |tag|
        concat(content_tag(:li) do
          tag.title
        end)
      end
    end
  end

  def text
    raw "@#{object.message.user.username}: #{upgraded_text_view}"
  end

  def public_channel_text
    if object.benchkiller_user&.company&.approved?
      benchkiller_user = object.benchkiller_user
      post = "From: @#{message.user.username}\n\n"
      post += "Company: #{benchkiller_user.company.title}\n\n"
      post += "Website: #{benchkiller_user.company.company_url}\n\n"
      post += "Email: #{benchkiller_user.company.email}\n\n"
      post += "Phone: #{benchkiller_user.company.phone}\n\n"
      post += "Region: #{benchkiller_user.company.place}\n\n"
      post += "Work region: #{benchkiller_user.company.regions_to_cooperate}\n\n"
      post += "Message:\n"
      post + object.message.text
    else
      object.text
    end
  end

  def approval_state_button_color(event)
    case event
    when :approve
      :success
    when :decline
      :danger
    end
  end

  private

  def upgraded_text_view
    object.message.text.gsub("\n", '<br/>').split.map do |part|
      part.split('<br/>').map do |word|
        if word.first == '#'
          content_tag(:span, style: 'color: #007bff') do
            word
          end
        else
          word
        end
      end.join('<br/>')
    end.join(' ')
  end

  class << self
    def collections
      %i[all unviewed approved declined]
    end

    def list_attributes
      %i[
        text
        tags_list
      ]
    end

    def show_attributes
      %i[
        id
        message_id
        state
        text
        tags_list
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
      #   filter_name: {
      #     type: :select,
      #     select_collection: filter_collection,
      #     query: lambda do |list, value|
      #       list.where some_attribute: value
      #     end
      #   },
      #   date_filter_name: {
      #     type: :dates,
      #     query: lambda do |list, begin_date, end_date|
      #       list.where 'created_at > ? AND created_at < ?', begin_date, end_date
      #     end
      #   }
      # }
    end
  end
end
