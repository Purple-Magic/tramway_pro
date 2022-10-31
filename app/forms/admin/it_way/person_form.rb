class Admin::ItWay::PersonForm < Tramway::Core::ApplicationForm
  properties :first_name, :last_name, :avatar, :project_id, :star_id

  def initialize(object)
    super(object).tap do
      form_properties first_name: :string,
        last_name: :string,
        avatar: :file,
        star_id: :integer
    end
  end
end
