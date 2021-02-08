# frozen_string_literal: true

module BotTelegram::Leopold
  module ItWayPro::WordsCheck
    def words_to_explain(text)
      return unless text.present?

      Word.all.map do |word|
        include_main = text.include?(word.main)
        include_synonim = word.synonims&.map do |synonim|
          text.include? synonim
        end&.include? true

        return word if include_main || include_synonim
      end.compact
    end
  end
end
