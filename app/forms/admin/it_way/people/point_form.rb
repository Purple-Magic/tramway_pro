class Admin::ItWay::People::PointForm < Tramway::Core::ApplicationForm
  properties :count, :comment, :project_id

  association :person

  def initialize(object)
    super(object).tap do
      form_properties person: :association,
        count: :integer,
        comment: :string
    end
  end
end
