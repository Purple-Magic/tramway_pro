# frozen_string_literal: true

class Admin::ChatQuestUlsk::ChapterForm < Tramway::Core::ApplicationForm
  properties :quest, :position, :project_id, :answers

  def initialize(object)
    super(object).tap do
      form_properties quest: :default,
                      position: :numeric,
                      answers: :string
    end
  end
end
