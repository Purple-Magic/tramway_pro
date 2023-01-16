# frozen_string_literal: true

class Benchkiller::Benchkiller::OfferForm < Tramway::ApplicationForm
  properties :message_id, :state, :project_id

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
      form_properties message_id: :integer,
        state: :text,
        project_id: :integer
    end
  end
end
