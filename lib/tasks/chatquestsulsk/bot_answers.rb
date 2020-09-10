module ChatQuestUlsk::BotAnswers
  def expecting_answers(game)
    if game&.current_position.present?
      ChatQuestUlsk::Message.find_by(quest: game.quest, position: game.current_position).answer.split(',')
    end
  end

  def right_answer?(game, answer)
    answers = expecting_answers(game)&.map(&:downcase)
    answer&.present? && answers&.any? && answers.include?(answer&.downcase)
  end
end
