require 'easy_jwt_auth'

describe EasyJwtAuth::TokenBuilder do
  describe '#build_token' do
    let(:token_builder) { EasyJwtAuth::TokenBuilder.new }
    subject { token_builder.build_token(100) }

    before(:each) do
      EasyJwtAuth::Config.tap do |c|
        c.set_algo 'HS256'
        c.set_expiration 120
        c.set_secret 'secret'
      end
    end

    it 'returns a jwt token with the proper data' do
      allow(Time).to receive(:now).and_return(1000)

      decoded_token = JWT.decode(
        subject, 'secret', true, { algorithm: 'HS256' }
      )

      expect(decoded_token.first['id']).to eq(100)
      expect(decoded_token.first['iat']).to eq(1000)
      expect(decoded_token.first['exp']).to eq(1120)
    end
  end
end

