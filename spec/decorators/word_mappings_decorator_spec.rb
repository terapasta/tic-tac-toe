require 'rails_helper'

RSpec.describe WordMappingsDecorator, type: :model do
  let!(:bot) do
    create(:bot)
  end

  def define_dict(word, synonym, bot = nil)
    create(:word_mapping, bot: bot, word: word).tap do |wm|
      wm.update(word_mapping_synonyms_attributes: [
        { value: synonym }
      ])
    end
  end

  let!(:system_word_mapping) do
    WordMapping.destroy_all
    define_dict('日程', 'スケジュール')
  end

  let!(:bot_word_mapping) do
    define_dict('予定表', 'スケジュール', bot)
  end

  let!(:bot_word_mapping_2) do
    define_dict('社内メール便', 'メール便', bot)
  end

  let!(:bot_word_mapping_3) do
    define_dict('JPG', 'JPEG', bot)
  end

  let!(:bot_word_mapping_4) do
    define_dict('POWER EGG', 'PE', bot)
  end

  let(:decorator) do
    WordMapping.for_bot(bot).decorate
  end

  describe '#replace_synonym' do
    subject do
      decorator.replace_synonym(text)
    end

    context '予定表' do
      let(:text) { Wakatifier.apply('スケジュールを教えて') }
      it { is_expected.to eq('予定 表 を 教え て ') }
    end

    context '社内メール便' do
      let(:text) { Wakatifier.apply('こんにちは。社内メール便を送りたいので、メール便の方法を教えてください。メール便は大好きです。社内メール便最高！メール便メール便社内メール便') }
      it { is_expected.to eq('こんにちは 。 社内 メール 便 を 送り たい ので 、 社内 メール 便 の 方法 を 教え て ください 。 社内 メール 便 は 大好き です 。 社内 メール 便 最高 ！ 社内 メール 便 社内 メール 便 社内 メール 便 ') }
    end

    context 'POWER EGG' do
      let(:text) { Wakatifier.apply('JPEGについて。PEは関係ない') }
      it { is_expected.to eq('JPG について 。 POWER EGG は 関係 ない ') }
    end
  end
end
