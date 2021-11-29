class MagicWood::ActorDecorator < Tramway::Core::ApplicationDecorator
  delegate_attributes(
        :id,
        :first_name,
        :last_name,
        :state,
        :project_id,
        :created_at,
        :updated_at,
  )

  decorate_associations :photos, :attendings

  def title
    "#{first_name} #{last_name}"
  end

  def portfolio
    content_tag(:div) do
      concat stylesheet_link_tag '/assets/red_magic/admin/photos'
      photos.each_slice(3).each do |batch|
        concat(content_tag(:div, class: :row) do
          batch.each do |photo|
            concat(content_tag(:div, class: :column) do
              concat(image_tag(photo.file.medium.url))
            end)
          end
        end)
      end
    end
  end

  def avatar
    if photos.any?
      image_tag photos.first.file.small.url
    end
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [ :all ]
    end

    def list_attributes
      [
        :avatar
      ]
    end

    def show_attributes
      [
        :portfolio
      ]
    end

    def show_associations
      [ :photos, :attendings ]
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
