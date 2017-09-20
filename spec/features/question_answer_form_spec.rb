require 'rails_helper'

RSpec.describe 'QuestionAnswerForm', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

  let!(:bot) do
    create(:bot, user: owner)
  end

  let!(:owner) do
    create(:user, plan: plan)
  end

  let!(:question_answer) do
    create(:question_answer, bot: bot)
  end

  let!(:topic_tags) do
    create_list(:topic_tag, 2, bot: bot)
  end

  before do
    sign_in owner
  end

  context 'when user as professional plan' do
    let(:plan) { :professional }

    feature 'new action' do
      subject do
        lambda do
          visit "/bots/#{bot.id}/question_answers/new"
          fill_in_input name: 'question_answer[question]', value: 'sample question'
          fill_in_input name: 'question_answer[answer]', value: 'sample answer body'
          click_link '添付ファイルを追加'
          within '#answer-files' do
            locator = all('input[type="file"]').first['name']
            attach_file locator, Rails.root.join('spec/fixtures/images/sample_naoki.jpg').to_s
          end
          fill_in_input id: 'topic-tag-name', value: 'ほげ'
          click_button '追加'
          check "topic-tag-#{topic_tags.first.id}"
          click_button '登録する'
        end
      end

      it { is_expected.to change(QuestionAnswer, :count).by(1) }
      it { is_expected.to change(TopicTagging, :count).by(1) }
      it { is_expected.to change(TopicTag, :count).by(1) }
      it { is_expected.to change(AnswerFile, :count).by(1) }
    end

    feature 'edit action' do
      subject do
        lambda do
          visit "/bots/#{bot.id}/question_answers/#{question_answer.id}/edit"
          fill_in_input name: 'question_answer[question]', value: 'updated question'
          fill_in_input name: 'question_answer[answer]', value: 'updated answer'
          click_button '更新する'
          question_answer.reload
        end
      end

      it { is_expected.to change(question_answer, :question).to('updated question') }
      it { is_expected.to change(question_answer, :answer).to('updated answer') }
      it { is_expected.not_to change(QuestionAnswer, :count) }
    end
  end

  context 'when user as lite or standard plan' do
    [:lite, :standard].each do |_plan|
      let(:plan) { _plan }

      feature 'new action' do
        subject do
          lambda do
            visit "/bots/#{bot.id}/question_answers/new"
            fill_in_input name: 'question_answer[question]', value: 'sample question'
            fill_in_input name: 'question_answer[answer]', value: 'sample answer body'
            expect(page.all('input[type="file"]').count).to be_zero
            fill_in_input id: 'topic-tag-name', value: 'ほげ'
            click_button '追加'
            check "topic-tag-#{topic_tags.first.id}"
            click_button '登録する'
          end
        end

        it { is_expected.to change(QuestionAnswer, :count).by(1) }
        it { is_expected.to change(TopicTagging, :count).by(1) }
        it { is_expected.to change(TopicTag, :count).by(1) }
        it { is_expected.to_not change(AnswerFile, :count) }
      end

      feature 'edit action' do
        subject do
          lambda do
            visit "/bots/#{bot.id}/question_answers/#{question_answer.id}/edit"
            fill_in_input name: 'question_answer[question]', value: 'updated question'
            fill_in_input name: 'question_answer[answer]', value: 'updated answer'
            click_button '更新する'
            question_answer.reload
          end
        end

        it { is_expected.to change(question_answer, :question).to('updated question') }
        it { is_expected.to change(question_answer, :answer).to('updated answer') }
        it { is_expected.not_to change(QuestionAnswer, :count) }
      end
    end
  end
end
