require 'rails_helper'

RSpec.describe ReplyResponse do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answers) do
    create_list(:question_answer, 2, bot: bot)
  end

  let!(:sub_question) do
    create(:sub_question, question_answer: question_answers.first)
  end

  let!(:learning_training_messages) do
    question_answers.map{ |it|
      bot.learning_training_messages.create(
        question_answer_id: it.id,
        question: it.question
      )
    } +
    [bot.learning_training_messages.create(
      question_answer_id: question_answers.first.id,
      question: sub_question.question,
      sub_question_id: sub_question.id
    )]
  end

  let(:raw_data) do
    {
      results: [
        {
          question_answer_id: question_answers.first.id,
          probability: 0.9,
          question: question_answers.first.question
        },
        {
          question_answer_id: question_answers.first.id,
          probability: 0.8,
          question: sub_question.question
        },
        {
          question_answer_id: question_answers.second.id,
          probability: 0.7,
          question: question_answers.second.question
        }
      ],
      question_feature_count: 3
    }
  end

  let(:reply_response) do
    ReplyResponse.new(raw_data, bot, 'hogehoge')
  end

  subject do
    reply_response.similar_question_answers
  end

  describe '#similar_question_answers' do
    context 'when included sub_question' do
      it { is_expected.to be_include(sub_question) }
      it { is_expected.to be_include(question_answers.second) }
    end
  end
end
