require 'rails_helper'

RSpec.describe Learning::Summarizer do
  let!(:bot) do
    create(:bot)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:sub_question) do
    create(:sub_question, question_answer: question_answer)
  end

  let!(:learning_training_message) do
    create(:learning_training_message, bot: bot)
  end

  let(:summarizer) do
    Learning::Summarizer.new(bot)
  end

  let(:model) do
    LearningTrainingMessage
  end

  describe '#summary' do
    subject do
      lambda do
        summarizer.summary
      end
    end

    it { is_expected.to change(model, :count).by(1) }
    it { is_expected.to change{model.find_by(id: learning_training_message.id)} }
    it { is_expected.to change{model.find_by(question: sub_question.question)} }
    it { is_expected.to change{model.find_by(question: question_answer.question)} }
  end
end