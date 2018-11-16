class ChatworkSimilarQuestionAnswerJob < ApplicationJob
  def perform(bot, chat, question_answer, chatwork_similar_question_answer)
    conn = Faraday.new(url: ENV['MYOPE_BOT_FRAMEWORK_HOST'])

    res = conn.post do |req|
      req.url "/chatwork/#{bot.token}/#{chat.id}/similarQuestionAnswer"
      req.headers['Content-Type'] = 'application/json'
      req.body = {
        question_answer_id: question_answer.id,
        question: chatwork_similar_question_answer.question.presence || question_answer.question,
        room_id: chatwork_similar_question_answer.room_id,
        from_account_id: chatwork_similar_question_answer.from_account_id
      }.to_json
    end
  end
end