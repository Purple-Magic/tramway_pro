class Estimation::ProjectDecorator < Tramway::Core::ApplicationDecorator
  # Associations you want to show in admin dashboard
  # decorate_associations :messages, :posts

  delegate_attributes :title, :state

  decorate_associations :tasks, :coefficients

  def table
    content_tag :table do
      concat(content_tag(:thead) do
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:title))
        end)
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:hours))
        end)
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:price))
        end)
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:specialists_count))
        end)
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:sum))
        end)
        concat(content_tag(:th) do
          concat(Estimation::Task.human_attribute_name(:sum_with_coefficients))
        end)
      end)
      tasks.each do |task|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat task.title
          end)
          concat(content_tag(:td) do
            concat task.hours
          end)
          concat(content_tag(:td) do
            concat task.price
          end)
          concat(content_tag(:td) do
            concat task.specialists_count
          end)
          concat(content_tag(:td) do
            concat task.sum
          end)
          concat(content_tag(:td) do
            concat task.sum_with_coefficients
          end)
        end)
      end
      concat(content_tag(:tr) do
        concat(content_tag(:td) do
        end)
        concat(content_tag(:td) do
        end)
        concat(content_tag(:td) do
        end)
        concat(content_tag(:td) do
          concat(content_tag(:b) do
            concat(Estimation::Project.human_attribute_name(:summary))
          end)
        end)
        concat(content_tag(:td) do
          concat(content_tag(:b) do
            concat(summary)
          end)
        end)
        ending_summary = coefficients.reduce(summary) do |result, coeff|
          result *= coeff.scale
        end
        concat(content_tag(:td) do
          concat(content_tag(:b) do
            concat(ending_summary)
          end)
        end)
      end)
      coefficients.each do |coefficient|
        concat(content_tag(:tr) do
          concat(content_tag(:td) do
            concat coefficient.title
          end)
          concat(content_tag(:td) do
            concat "#{(coefficient.scale * 100 - 100).round(0)} %"
          end)
          concat(content_tag(:td) do
          end)
          concat(content_tag(:td) do
          end)
          concat(content_tag(:td) do
          end)
          concat(content_tag(:td) do
          end)
        end)
      end
    end
  end

  def summary
    tasks.sum(&:sum)
  end

  def project_state
    state_machine_view object, :project_state
  end

  def project_state_button_color(event)
    case event
    when :send_to_customer
      :primary
    when :finish_estimation, :confirmed_by_customer
      :success
    when :decline
      :warning
    end
  end

  class << self
    def collections
      # [ :all, :scope1, :scope2 ]
      [:all]
    end

    def list_attributes
      [
        :project_state
      ]
    end

    def show_attributes
      %i[
        id
        title
        table
      ]
    end

    def show_associations
      %i[tasks coefficients]
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
