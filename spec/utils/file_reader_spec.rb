require 'rails_helper'

RSpec.describe FileReader do
  let(:expected_text) do
    "ヘッダー\n,,ほげほげ№㏍℡㊤㊥㊦㊧㊨㈱㈲㈹㍾㍽㍼㍻㎜㎝㎞㎎㎏㏄㎡㍉㌔㌢㍍㌘㌧㌃㌶㍑㍗㌍㌦㌣㌫㌻①②③④⑤⑥⑦⑧⑨⑩⑪⑫⑬⑭⑮⑯⑰⑱⑲⑳ⅠⅡⅢⅣⅤⅥⅦⅧⅨⅩ〝〟⊥ふがふが----,回答です\n"
  end

  describe '#read' do
    subject do
      FileReader.new(file_path: file_path, encoding: Encoding::Shift_JIS).read
    end

    context 'when sjis encoding with incompatible characters' do
      let(:file_path) do
        Rails.root.join('spec/fixtures/sjis-test.csv')
      end

      it 'can reads' do
        expect(subject).to eq(expected_text)
      end
    end
  end
end