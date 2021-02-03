module BotTelegram
  module Leopold
    module ItWayPro
      module WordsCheck
        def words_to_explain(text)
          Word.all.map do |word|
            include_main = text.includes?(word.main)
            include_synonim = word.synonims.map do |synonim|
              text.includes? synonim
            end.includes? true

            return word if include_main || include_synonim
          end.compact
        end
      end
    end
  end
end
