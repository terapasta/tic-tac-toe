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
      -> { summarizer.summary }
    end

    context 'normal' do
      it { is_expected.to change(model, :count).by(1) }
      it { is_expected.to change{model.find_by(id: learning_training_message.id)}.to(nil).from(learning_training_message) }
      it { is_expected.to change{model.find_by(question: sub_question.question)}.from(nil) }
      it { is_expected.to change{model.find_by(question: question_answer.question)}.from(nil) }
    end

    context 'when error occur' do
      before do
        allow_any_instance_of(Learning::Summarizer).to \
          receive(:convert_question_answers!).and_raise('some error')
      end

      it 'rollback' do
        expect{
          expect{ subject.call }.to raise_error(RuntimeError)
        }.to_not change{ model.pluck(:id) }
      end
    end
  end
end