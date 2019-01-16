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
      question_feature_count: 3,
      noun_count: 2,
      verb_count: 1,
    }
  end

  let(:reply_response) do
    ReplyResponse.new(raw_data, bot, 'hogehoge', 'hogehoge')
  end

  describe '#similar_question_answers' do
    context 'when included sub_question' do
      context 'testing similar_question_answers' do
        subject do
          reply_response.similar_question_answers
        end

        it { is_expected.to be_include(sub_question) }
        it { is_expected.to be_include(question_answers.second) }
      end

      context 'testing question_answer' do
        subject do
          reply_response.question_answer
        end

        it { is_expected.to satisfy{|qa| qa.no_classified? == false} }
      end
    end

    context 'when noun_count is equal to 1 and verb count is equal to 0' do
      let(:raw_data) do
        {
          results: [
            {
              question_answer_id: question_answers.first.id,
              probability: 0.7,
              question: question_answers.first.question
            },
          ],
          question_feature_count: 3,
          noun_count: 1,
          verb_count: 0,
        }
      end

      let(:reply_response) do
        bot.learning_parameter = LearningParameter.new(classify_threshold: 0.6)
        ReplyResponse.new(raw_data, bot, 'hogehoge', 'hogehoge')
      end

      context 'testing similar_question_answers' do
        subject do
          reply_response.similar_question_answers
        end

        # noun count = 1、verb count = 0 の場合、classify_threshold が 0.9 にまで引き上げられる
        # したがって、similar_question_answers に question_answers.first を含む
        it { is_expected.to be_include(question_answers.first)}
      end

      context 'testing question_answer' do
        subject do
          reply_response.question_answer
        end

        # noun count = 1、verb count = 0 の場合、classify_threshold が 0.9 にまで引き上げられる
        # これに応じて question_answerメソッドも NO_CLASSIFIED を返す
        it { is_expected.to satisfy {|qa| qa.no_classified? == true}}
      end
    end

    # 閾値（learning_parameter.classify_threashold | default = 0.6）よりも小さい
    # probability の場合は、shift せずに全て表示
    context 'when questions with low probabilities returned' do

      let(:raw_data) do
        {
          results: [
            {
              question_answer_id: question_answers.first.id,
              probability: 0.5,
              question: question_answers.first.question
            },
            {
              question_answer_id: question_answers.first.id,
              probability: 0.4,
              question: sub_question.question
            },
            {
              question_answer_id: question_answers.second.id,
              probability: 0.2,
              question: question_answers.second.question
            }
          ],
          question_feature_count: 3,
          noun_count: 2,
          verb_count: 1,
        }
      end

      context 'testing similar_question_answers' do
        subject do
          reply_response.similar_question_answers
        end

        it { is_expected.to be_include(question_answers.first) }
        it { is_expected.to be_include(sub_question) }
        it { is_expected.to be_include(question_answers.second) }
      end

      context 'testing question_answer' do
        subject do
          reply_response.question_answer
        end

        it { is_expected.to satisfy{|qa| qa.no_classified? == true} }
      end

    end

  end
end
