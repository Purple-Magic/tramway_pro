# frozen_string_literal: true

class Benchkiller::Collation < ApplicationRecord
  search_by :main, :words

  def all_words
    [main] + words
  end
end
