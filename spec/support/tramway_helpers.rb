# frozen_string_literal: true

module TramwayHelpers
  def click_on_association_delete_button(object)
    delete_path = ::Tramway::Admin::Engine.routes.url_helpers.record_path(
      object.id,
      model: object.class
    )
    row = find("td[colspan='2'] td a[href='#{delete_path}']").parent_node(level: 2)
    row.find('td button.delete[type="submit"]').click
  end

  def click_on_tab(text)
    find('li.nav-item a.nav-link', text: text).click
  end

  def click_on_table_item(text)
    find('table td a', text: text).click
  end

  def click_on_delete_button(object)
    delete_path = ::Tramway::Admin::Engine.routes.url_helpers.record_path(
      object.id,
      model: object.class
    )
    find("form[action='#{delete_path}']").click
  end
end
