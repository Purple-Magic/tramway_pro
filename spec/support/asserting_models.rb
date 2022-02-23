# frozen_string_literal: true

module AssertingModels
  def assert_attributes(object, attributes, additionals: nil)
    send "assert_#{object.class.name.underscore.gsub('/', '_')}", object, attributes, additionals
  end

  def assert_courses_screencast(actual_object, attributes, additionals)
    attributes.each_key do |attr|
      case attr
      when :video
        actual = actual_object.video_id
        expecting = additionals[:video].id
      else
        actual = actual_object.send(attr)
        expecting = attributes[attr]
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end
