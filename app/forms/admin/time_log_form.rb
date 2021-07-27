# frozen_string_literal: true

class Admin::TimeLogForm < Tramway::Core::ApplicationForm
  properties :associated_type, :associated_id, :time_spent, :comment

  def initialize(object)
    super(object).tap do
      # Here is the mapping from model attributes to simple_form inputs.
      # form_properties title: :string,
      #   logo: :file,
      #   description: :ckeditor,
      #   games: :association,
      #   date: :date_picker,
      #   text: :text,
      #   birth_date: {
      #     type: :default,
      #     input_options: {
      #       hint: 'It should be more than 18'
      #     }
      #   }
      form_properties associated_type: :text,
        associated_id: :integer,
        time_spent: :text,
        comment: :text
    end
  end
end
