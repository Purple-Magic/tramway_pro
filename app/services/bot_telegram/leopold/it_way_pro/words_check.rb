# frozen_string_literal: true

module BotTelegram::Leopold::ItWayPro::WordsCheck
  def words_to_explain(text)
    return unless text.present?

    Word.all.map do |word|
      include_main = text.match?(/\b#{word.main}\b/)
      include_synonim = word.synonims&.map do |synonim|
        text.match?(/\b#{synonim}\b/)
      end&.include? true

      return word if include_main || include_synonim
    end.compact
  end
end
