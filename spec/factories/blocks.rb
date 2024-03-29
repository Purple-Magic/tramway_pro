# frozen_string_literal: true

FactoryBot.define do
  factory :block, class: Tramway::Landing::Block do
    page
    title
    position { generate :integer }
    block_type { Tramway::Landing::Block.block_type.values.sample }
    navbar_link { Tramway::Landing::Block.navbar_link.values.sample }
    anchor { generate :string }
    description { generate :string }
    view_name { generate :string }
  end

  factory :block_admin_attributes, class: Tramway::Landing::Block do
    title
    position { generate :integer }
    block_type { Tramway::Landing::Block.block_type.values.sample.text }
    navbar_link { Tramway::Landing::Block.navbar_link.values.sample.text }
    anchor { generate :string }
    view_name { generate :string }
  end
end
