class Admin::ItWay::PersonForm < Tramway::ApplicationForm
  properties :first_name, :last_name, :avatar, :project_id, :star_id, :telegram_user_id, :event_person_id

  def initialize(object)
    super(object).tap do
      form_properties first_name: :string,
        last_name: :string,
        avatar: :file,
        event_person_id: :integer,
        star_id: :integer,
        telegram_user_id: :integer
    end
  end
end
