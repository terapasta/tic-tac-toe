require 'rails_helper'

RSpec.shared_examples_for HasManySentenceSynonyms do |target_attr|
  let!(:bot) do
    create(:bot)
  end

  let!(:answer) do
    create(:answer, bot: bot)
  end

  let!(:resource) do
    create(described_class.name.underscore, bot: bot, answer: answer)
  end

  let!(:sentence_synonyms) do
    create_list(:sentence_synonym, 3,
      question_answer_id: resource.id,
      created_user_id: 1
    )
  end

  context 'when changed parent text' do
    it 'deassociates all sentence_synonyms' do
      expect(resource.sentence_synonyms).to match_array(sentence_synonyms)
      resource.update(target_attr => 'updated text')
      resource.reload
      expect(resource.sentence_synonyms).to eq([])
    end
  end

  context 'when not changed parent text' do
    it 'still associate all sentence_synonyms' do
      expect(resource.sentence_synonyms).to match_array(sentence_synonyms)
      resource.update(target_attr => resource.send(target_attr))
      resource.reload
      expect(resource.sentence_synonyms).to match_array(sentence_synonyms)
    end
  end
end

RSpec.describe QuestionAnswer do
  it_behaves_like HasManySentenceSynonyms, :question
end

RSpec.describe TrainingMessage do
  it_behaves_like HasManySentenceSynonyms, :body
end
