require 'easy_jwt_auth'

describe EasyJwtAuth::UserFinder do
  describe '#user_from_header' do
    let(:user_finder) { EasyJwtAuth::UserFinder.new }
    subject { user_finder.user_from_header(header) }

    before(:each) do
      EasyJwtAuth::Config.tap do |c|
        c.set_algo 'HS256'
        c.set_expiration 120
        c.set_secret 'secret'
        c.set_finder_method ->(id) { id }
      end
    end

    context 'with invalid auth header' do
      let(:header) { 'invalidheader' }

      it 'raises InvalidAuthHeader exception' do
        expect { subject }.to raise_error(EasyJwtAuth::InvalidAuthHeader)
      end
    end

    context 'with invalid token' do
      let(:header) { 'Bearer invalidtoken' }

      it 'raises JWT::DecodeError exception' do
        expect { subject }.to raise_error(JWT::DecodeError)
      end
    end

    context 'with expired token in header' do
      let(:header) { 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MTAwLCJleHAiOjE0OTI2MDE1Mzd9.tVaqRHZpcwcL4nj7i_CDlzlcKh9961GwjTGifugw1bw' }
      it 'raises JWT::ExpiredSignature exception' do
        expect { subject }.to raise_error(JWT::ExpiredSignature)
      end
    end

    context 'with valid token' do
      let(:header) { "Bearer #{EasyJwtAuth::TokenBuilder.new.build_token(100)}" }

      it 'returns the user identified by the finder method' do
        expect(subject).to eq(100)
      end
    end
  end
end


