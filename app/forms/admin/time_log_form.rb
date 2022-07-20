# frozen_string_literal: true

class Admin::TimeLogForm < Tramway::Core::ApplicationForm
  properties :time_spent, :comment, :associated_type, :project_id, :passed_at

  association :associated
  association :user

  def initialize(object)
    super(object).tap do
      form_properties user: :association,
        associated: :polymorphic_association,
        time_spent: {
          type: :string,
          input_options: {
            placeholder: 'Формат 3h 10m'
          }
        },
        passed_at: :date_picker,
        comment: :string
    end
  end
end
