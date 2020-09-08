module ChatQuestUlsk::BotAnswers
  def expecting_answers(game)
    if game&.current_position.present?
      ChatQuestUlsk::Message.find_by(quest: game.quest, position: game.current_position).answer
    end
  end
end
