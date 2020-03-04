# frozen_string_literal: true

module IntegrationHelpers
  def click_on_link_by_href(href, options = {})
    button = find compile_attributes(href: href), options
    button.click
  end

  def click_on_destroy_link_by_href(href, options = {})
    button = find compile_attributes(href: href, 'data-method' => :delete), options
    button.click
  end

  def click_on_check_box(text)
    find(:label, text: text).click
  end

  def move_host_to(host)
    Capybara.app_host = 'http://' + host + ':3000'
  end

  private

  def compile_attributes(attributes = {})
    param = '//a'
    attributes.keys.each do |attribute|
      param += "[@#{attribute}='#{attributes[attribute]}']"
    end
    param
  end
end
