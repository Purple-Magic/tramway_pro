# frozen_string_literal: true

module ErrorsHelper
  def problem_with(attr:, expecting:, actual:)
    "Problem with #{attr}. Expected #{expecting}:#{expecting.class}. Got #{actual}:#{actual.class}.
    Maybe you forgot add fill_in method for this attribute"
  end
end
