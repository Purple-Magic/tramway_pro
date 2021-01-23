module BotTelegram
  module Leopold
    module ItWay
      module WordsCheck
        def words_to_explain(text)
          ['.', ',', '!', ':', ';', '(', ')', '@'].each do |symbol|
            text.gsub! symbol, ''
          end
          words = text.split(' ')
          words.map do |word|
            Word.where(main: word.downcase) + (Word.all.select do |record|
              record.synonims&.include? word.downcase
            end)
          end.flatten.uniq
        end
      end
    end
  end
end
