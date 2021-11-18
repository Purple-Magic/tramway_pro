class Benchkiller::OfferDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes(
        :id,
        :message_id,
        :state,
        :project_id,
        :created_at,
        :updated_at,
        :uuid
  )

  decorate_associations :tags

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
    "#{object.message.user.username}: #{object.message.text}"
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :text,
        :tags_list
      ]
    end

    def show_attributes
      [
        :id,
        :message_id,
        :state,
        :text,
        :tags_list,
        :created_at,
        :updated_at,
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
