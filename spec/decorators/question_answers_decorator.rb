require 'rails_helper'

describe QuestionAnswersDecorator do
  let(:bot) do
    create(:bot, user: create(:user))
  end

  let!(:question_answer_1) do
    bot.question_answers.create(question: '質問1', answer: '回答1').tap do |qa|
      qa.decision_branches.create(body: '選択肢1', answer: '選択肢1回答', bot: bot).tap do |db|
        db.child_decision_branches.create(body: '選択肢1-1', answer: '選択肢1-1回答', bot: bot)
        db.child_decision_branches.create(body: '選択肢1-2', answer: '選択肢1-2回答', bot: bot)
      end
      qa.decision_branches.create(body: '選択肢2', answer: '選択肢2回答', bot: bot)
    end
  end

  let!(:question_answer_2) do
    bot.question_answers.create(question: '質問2', answer: '回答2').tap do |qa|
      qa.decision_branches.create(body: '選択肢3', answer: '選択肢3回答', bot: bot)
    end
  end

  let!(:question_answer_3) do
    bot.question_answers.create(question: '質問3', answer: '回答3', bot: bot)
  end

  subject do
    bot.question_answers.decorate.to_csv
  end

  it do
    expect(subject).to eq [
      "#{question_answer_1.id},質問1,回答1,選択肢1,選択肢1回答,選択肢1-1,選択肢1-1回答\r\n",
      "#{question_answer_1.id},質問1,回答1,選択肢1,選択肢1回答,選択肢1-2,選択肢1-2回答\r\n",
      "#{question_answer_1.id},質問1,回答1,選択肢2,選択肢2回答\r\n",
      "#{question_answer_2.id},質問2,回答2,選択肢3,選択肢3回答\r\n",
      "#{question_answer_3.id},質問3,回答3\r\n",
    ].join
  end
end
