# frozen_string_literal: true

class Skillbox::Courses::CommentForm < Tramway::Core::ApplicationForm
  properties :begin_time, :end_time, :project_id, :text, :file, :phrase, :associated_type, :associated_id

  association :associated

  def initialize(object)
    super(object).tap do
      form_properties associated: :polymorphic_association,
        begin_time: :string,
        end_time: :string,
        phrase: :string,
        text: :text,
        file: :file
    end
  end
end
