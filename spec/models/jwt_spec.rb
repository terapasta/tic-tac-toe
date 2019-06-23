require 'rails_helper'

RSpec.describe 'Jwt' do
  let!(:user) do
    create(:user)
  end

  describe '.generate' do
    context 'when user is saved' do
      it 'returns a token' do
        expect{
          token = Jwt.generate(user)
          expect(token.is_a?(String)).to be
        }.to_not raise_error
      end
    end

    context 'when user isnt saved' do
      it 'raises an error' do
        expect{
          Jwt.generate(User.new)
        }.to raise_error(Jwt::InvalidUserError)
      end
    end

    context 'when argument isnt an instance of User' do
      it 'raises an error' do
        expect{
          Jwt.generate(QuestionAnswer.new)
        }.to raise_error(Jwt::InvalidUserError)
      end
    end
  end

  describe '.parse' do
    let!(:token) do
      Jwt.generate(user)
    end

    context 'when the token isnt expired' do
      it 'returns a decoded token' do
        decoded_token = Jwt.parse(token)
        expect(decoded_token['iss']).to eq('test')
        expect(decoded_token['exp'].is_a?(Integer)).to be
        expect(decoded_token['iat'].is_a?(Integer)).to be
        expect(decoded_token['user_id']).to eq(user.id)
      end
    end

    context 'when the token is expired' do
      before do
        Timecop.travel(3.hours.since)
      end

      after do
        Timecop.return
      end

      it 'raises error' do
        expect{
          Jwt.parse(token)
        }.to raise_error(JWT::ExpiredSignature)
      end
    end

    context 'when the iss does not match' do
      before do
        allow(Rails).to receive(:env).and_return('hoge')
      end

      after do
        ::RSpec::Mocks.space.proxy_for(Rails).remove_stub(:env)
      end

      it 'raises an error' do
        expect{
          Jwt.parse(token)
        }.to raise_error(Jwt::InvalidTokenError)
      end
    end
  end
end
