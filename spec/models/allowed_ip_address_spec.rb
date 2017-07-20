require 'rails_helper'

RSpec.describe AllowedIpAddress do
  let!(:user) do
    create(:user, role: :staff)
  end

  let!(:bot) do
    create(:bot, user: user)
  end

  context 'IPv4の場合' do
    it 'バリデーションが成功すること' do
      allowed_ip_address = AllowedIpAddress.new(value: '122.132.195.11', bot: bot)
      expect(allowed_ip_address).to be_valid
    end
  end

  context 'IPv6の場合' do
    it 'レコードが追加されること' do
      allowed_ip_address = AllowedIpAddress.new(value: 'ABCD:EF01:2345:6789:ABCD:EF01:2345:6789', bot: bot)
      expect(allowed_ip_address).to be_valid
    end
  end

  context 'ブランクの場合' do
    it 'レコードが追加されないこと' do
      allowed_ip_address = AllowedIpAddress.new(value: '', bot: bot)
      expect(allowed_ip_address).to_not be_valid
    end
  end

  context 'IPアドレスフォーマット以外の場合' do
    it 'レコードが追加されないこと' do
      allowed_ip_address = AllowedIpAddress.new(value: 'hogehoge', bot: bot)
      expect(allowed_ip_address).to_not be_valid
    end
  end

end
