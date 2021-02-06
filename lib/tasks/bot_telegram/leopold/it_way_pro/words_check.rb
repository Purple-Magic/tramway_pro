module BotTelegram
  module Leopold
    module ItWayPro
      module WordsCheck
        def words_to_explain(text)
          if text.present?
            Word.all.map do |word|
              include_main = text.include?(word.main)
              include_synonim = word.synonims.map do |synonim|
                text.include? synonim
              end.includes? true

              return word if include_main || include_synonim
            end.compact
          end
        end
      end
    end
  end
end
