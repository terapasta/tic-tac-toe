require 'rails_helper'

RSpec.describe 'QuestionAnswerForm', type: :feature, js: true do
  include RequestSpecHelper
  include CapybaraHelpers

  let!(:bot) do
    create(:bot)
  end

  let!(:tutorial) do
    # NOTE:
    # tutorial は自動生成される
    # https://www.pivotaltracker.com/n/projects/1879711/stories/164098607
    bot.tutorial
  end

  let!(:owner) do
    create(:user)
  end

  let!(:organization) do
    create(:organization, plan: plan).tap do |org|
      org.user_memberships.create(user: owner)
      org.bot_ownerships.create(bot: bot)
    end
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
      before do
        create_list(:question_answer, 49, bot: bot)
      end

      subject do
        lambda do
          visit "/bots/#{bot.id}/question_answers/new"
          find('[name="question_answer[question]"]').set('sample question')
          find('[name="question_answer[answer]"]').set('sample answer body')
          click_link '添付ファイルを追加'
          within '#answer-files' do
            locator = all('input[type="file"]').first['name']
            attach_file locator, Rails.root.join('spec/fixtures/images/sample_naoki.jpg').to_s
          end
          find('#topic-tag-name').set('ほげ')
          # fill_in_input id: 'topic-tag-name', value: 'ほげ'
          click_button '追加'
          check "topic-tag-#{topic_tags.first.id}"
          page.execute_script "window.scrollBy(0, window.innerHeight)"
          click_button '登録する'
        end
      end

      it { is_expected.to change(QuestionAnswer, :count).by(1) }
      it { is_expected.to change(TopicTagging, :count).by(1) }
      it { is_expected.to change(TopicTag, :count).by(1) }
      it { is_expected.to change(AnswerFile, :count).by(1) }
      it { expect(bot.reload.tutorial.fifty_question_answers).to be }
    end

    feature 'edit action' do
      subject do
        lambda do
          visit "/bots/#{bot.id}/question_answers/#{question_answer.id}/edit"
          find('[name="question_answer[question]"]').set('updated question')
          find('[name="question_answer[answer]"]').set('updated answer')
          # fill_in_input name: 'question_answer[question]', value: 'updated question'
          # fill_in_input name: 'question_answer[answer]', value: 'updated answer'
          page.execute_script "window.scrollBy(0, window.innerHeight)"
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
            find('[name="question_answer[question]"]').set('sample question')
            find('[name="question_answer[answer]"]').set('sample answer body')
            # fill_in_input name: 'question_answer[question]', value: 'sample question'
            # fill_in_input name: 'question_answer[answer]', value: 'sample answer body'
            expect(page.all('input[type="file"]').count).to be_zero
            find('#topic-tag-name').set('ほげ')
            fill_in_input id: 'topic-tag-name', value: 'ほげ'
            click_button '追加'
            check "topic-tag-#{topic_tags.first.id}"
            page.execute_script "window.scrollBy(0, window.innerHeight)"
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
            find('[name="question_answer[question]"]').set('updated question')
            find('[name="question_answer[answer]"]').set('updated answer')
            # fill_in_input name: 'question_answer[question]', value: 'updated question'
            # fill_in_input name: 'question_answer[answer]', value: 'updated answer'
            page.execute_script "window.scrollBy(0, window.innerHeight)"
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
