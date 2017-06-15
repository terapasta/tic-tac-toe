require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let!(:bot) do
    create(:bot)
  end

  let!(:staff) do
    create(:user, :staff)
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  let!(:answer_file) do
    answer.answer_files.create(file: sample_image)
  end

  let!(:descision_branch) do
    create(:decision_branch, answer: answer, bot: bot)
  end

  let!(:parent_decision_branch) do
    create(:decision_branch, next_answer: answer, bot: bot)
  end

  let!(:training_message) do
    create(:training_message, answer: answer, bot: bot)
  end

  let!(:question_answer) do
    create(:question_answer, answer: answer, bot: bot)
  end

  let(:sample_image) do
    Rails.root.join('spec/fixtures/images/sample_naoki.jpg').open
  end

  describe 'PUT #update' do
    before do
      sign_in staff
    end

    subject do
      lambda do
        put :update, bot_id: bot.id, id: answer.id, answer: { body: body }, format: :json
      end
    end

    context 'when not changed body' do
      let(:body) do
        answer.body
      end

      it { expect{subject}.to_not change(Answer, :count) }
    end

    context 'when changed body' do
      let(:body) do
        "updated body"
      end

      let(:old_answer) do
        assigns(:old_answer)
      end

      let(:new_answer) do
        assigns(:answer)
      end

      it { is_expected.to change(Answer, :count).by(1) }

      it 'new_answer has answer_files, decision_branches, training_messages, question_answers and parent_decision_branch' do
        subject.call
        expect(new_answer.answer_files).to eq([answer_file])
        expect(new_answer.decision_branches).to eq([descision_branch])
        expect(new_answer.training_messages).to eq([training_message])
        expect(new_answer.question_answers).to eq([question_answer])
        expect(new_answer.parent_decision_branch).to eq(parent_decision_branch)
      end

      it 'old_answer not has answer_files, decision_branches, training_messages, question_answers and parent_decision_branch' do
        subject.call
        answer.reload
        expect(answer.answer_files).to be_blank
        expect(answer.decision_branches).to be_blank
        expect(answer.training_messages).to be_blank
        expect(answer.question_answers).to be_blank
        expect(answer.parent_decision_branch).to be_nil
      end
    end
  end
end
