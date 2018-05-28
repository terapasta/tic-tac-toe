require 'rails_helper'

RSpec.describe TimeMeasurement do
  # describe '.measure' do
  #   subject do
  #     TimeMeasurement.measure(name: 'サンプル', bot: Bot.new) do
  #       sleep sleep_seconds
  #     end
  #   end

  #   context 'when spend over 1sec' do
  #     let(:sleep_seconds) do
  #       1
  #     end

  #     specify do
  #       expect_any_instance_of(Slack::Notifier).to receive(:post).with(text: /^1秒以上かかる処理が発生しました/, channel: '#dev')
  #       subject
  #     end
  #   end

  #   context 'when under 1sec' do
  #     let(:sleep_seconds) do
  #       0.5
  #     end

  #     specify do
  #       expect_any_instance_of(Slack::Notifier).to_not receive(:post)
  #       subject
  #     end
  #   end
  # end
end
