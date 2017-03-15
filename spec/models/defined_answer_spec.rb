require 'rails_helper'

RSpec.describe DefinedAnswer, :type => :model do
  describe 'validations' do
    subject(:defined_answer) { build(:defined_answer, body: 'hoge') }
    context 'when bot_id is nil' do
      before { defined_answer.bot_id = nil }
      it { is_expected.to be_valid }
    end
  end
end
