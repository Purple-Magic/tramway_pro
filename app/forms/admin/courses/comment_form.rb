# frozen_string_literal: true

class Admin::Courses::CommentForm < Tramway::Core::ApplicationForm
  properties :begin_time, :end_time, :project_id, :text

  association :video

  def initialize(object)
    super(object).tap do
      form_properties video: :association,
        begin_time: :string,
        end_time: :string,
        text: :text
    end
  end
end
