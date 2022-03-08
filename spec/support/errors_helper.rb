# frozen_string_literal: true

module ErrorsHelper
  def problem_with(attr:, expecting:, actual:, **options)
    optional_info = options.reduce('') do |line, (key, value)|
      line += "#{key}: #{value}"
    end

    "Problem with #{attr}. Expected #{expecting}:#{expecting.class}. Got #{actual}:#{actual.class}.
    Maybe you forgot add fill_in method for this attribute.
    MORE INFO: #{optional_info}"
  end
end
