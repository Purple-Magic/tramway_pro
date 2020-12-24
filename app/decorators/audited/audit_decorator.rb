class Audited::AuditDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts
  
  delegate_attributes :username, :action, :audited_changes, :version, :comment, :remote_address, :request_uuid, :created_at

  decorate_association :user

  def title
    if object.user_type == 'Tramway::User::User'
      "#{user.title} #{object.action} #{object.auditable_type} ##{object.auditable_id}"
    else
      "#{object.action} #{object.auditable_type} ##{object.auditable_id}"
    end
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :audited_changes,
      ]
    end

    def show_attributes
      [
        :username,
        :action,
        :audited_changes,
        :version,
        :comment,
        :remote_address,
        :request_uuid,
        :created_at,
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

  # delegate_attributes :title
end
