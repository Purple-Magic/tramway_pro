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

  def assert_tramway_event_event(actual_object, attributes, _additionals)
    attributes.each_key do |attr|
      actual = actual_object.send(attr)
      expecting = attributes[attr]
      if attr.in? %i[begin_date end_date request_collecting_end_date request_collecting_begin_date]
        actual = actual.to_datetime.strftime('%d.%m.%Y %H:%M:%S')
        expecting = expecting.strftime('%d.%m.%Y %H:%M:%S')
      end
      case actual.class.to_s
      when 'NilClass'
        expect(actual).not_to be_empty, "#{attr} is empty"
      when 'Enumerize::Value'
        expect(actual).not_to be_empty, "#{attr} is empty"
        actual = actual.text
      when 'PhotoUploader'
        actual = actual.path.split('/').last
        expecting = expecting.to_s.split('/').last
      end
      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end

  def assert_courses_task(actual_object, attributes, _additionals)
    attributes.each_key do |attr|
      next if attr == :lesson

      actual = actual_object.send(attr)
      expecting = attributes[attr]

      case attr
      when :text
        actual = actual.strip!
      end

      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end

  def assert_courses_video(actual_object, attributes, _additionals)
    attributes.each_key do |attr|
      next if attr == :lesson

      actual = actual_object.send(attr)
      expecting = attributes[attr]
      case attr
      when :text
        actual = actual.strip!
      when :release_date
        actual = actual.to_datetime.strftime('%d.%m.%Y %H:%M:%S')
        expecting = expecting.strftime('%d.%m.%Y %H:%M:%S')
      end

      expect(actual).to eq(expecting), problem_with(attr: attr, expecting: expecting, actual: actual)
    end
  end
end
