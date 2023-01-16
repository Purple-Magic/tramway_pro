# frozen_string_literal: true

class Admin::TimeLogForm < Tramway::ApplicationForm
  properties :time_spent, :comment, :associated_type, :project_id, :passed_at

  association :associated
  association :user

  def initialize(object)
    super(object).tap do
      object.passed_at = DateTime.now.strftime('%d.%m.%Y')

      form_properties user: :association,
        associated: :polymorphic_association,
        time_spent: {
          type: :string,
          input_options: {
            placeholder: 'Формат 3h 10m',
          }
        },
        passed_at: :date_picker,
        comment: :string
    end
  end
end
