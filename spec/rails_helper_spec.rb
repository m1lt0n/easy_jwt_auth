require 'easy_jwt_auth'

describe EasyJwtAuth::RailsHelper do
  include EasyJwtAuth::RailsHelper

  before(:each) do
    EasyJwtAuth::Config.tap do |c|
      c.set_algo 'HS256'
      c.set_expiration 120
      c.set_secret 'secret'
      c.set_finder_method ->(id) { id }
    end

    allow_any_instance_of(EasyJwtAuth::RailsHelper).to receive(:request).and_return(double(headers: { 'Authorization' => auth_header }))
  end

  describe '#jwt_current_user' do
    subject { jwt_current_user }

    context 'with valid authorization header' do
      let(:auth_header) { "Bearer #{EasyJwtAuth::TokenBuilder.new.build_token(100)}" }

      it 'returns the user based on the token' do
        expect(subject).to eq(100)
      end
    end

    context 'with invalid authorization header' do
      let(:auth_header) { "Bearer invalid" }

      it 'returns nil' do
        expect(subject).to be_nil
      end
    end
  end

  describe '#jwt_authenticate!' do
    subject { jwt_authenticate! }

    context 'without authenticated user' do
      let(:auth_header) { "Bearer invalid" }

      it 'returns an empty 403 response' do
        allow_any_instance_of(EasyJwtAuth::RailsHelper).to receive(:head).with(403).and_return('forbidden')

        expect(subject).to eq('forbidden')
      end
    end

    context 'with authenticated user' do
      let(:auth_header) { "Bearer #{EasyJwtAuth::TokenBuilder.new.build_token(100)}" }

      it 'does nothing' do
        expect_any_instance_of(EasyJwtAuth::RailsHelper).not_to receive(:head)

      end
    end
  end
end

