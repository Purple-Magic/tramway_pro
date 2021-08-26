# frozen_string_literal: true

class Admin::TimeLogForm < Tramway::Core::ApplicationForm
  properties :time_spent, :comment, :associated_type, :project_id

  association :associated
  association :user

  def initialize(object)
    super(object).tap do
      form_properties user: :association,
        associated: :polymorphic_association,
        time_spent: :string,
        comment: :string
    end
  end
end
