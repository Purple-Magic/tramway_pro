# frozen_string_literal: true

class Admin::Podcast::StarForm < Tramway::Core::ApplicationForm
  properties :nickname, :link, :project_id, :vk, :twitter, :telegram, :instagram, :first_name, :last_name

  association :podcast

  def initialize(object)
    super(object).tap do
      form_properties podcast: :association,
        nickname: :string,
        first_name: :string,
        last_name: :string,
        link: :string,
        vk: :string,
        twitter: :string,
        telegram: :string,
        instagram: :string
    end
  end
end
