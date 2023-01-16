# frozen_string_literal: true

class Benchkiller::Benchkiller::NotificationForm < Tramway::ApplicationForm
  properties :text, :send_at, :state, :project_id, :sending_state

  def initialize(object)
    super(object).tap do
      form_properties text: :text,
        send_at: {
          type: :string,
          input_options: {
            placeholder: '00:00 (МСК)'
          }
        }
    end
  end
end
