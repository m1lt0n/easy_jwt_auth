require 'easy_jwt_auth'

describe EasyJwtAuth::Config do
  let(:config) { EasyJwtAuth::Config }

  describe '#set_expiration' do
    subject { config.set_expiration(100) }

    it 'sets the expiration class instance attribute' do
      subject
      expect(config.expiration).to eq(100)
    end
  end

  describe '#set_algo' do
    subject { config.set_algo('HS256') }

    it 'sets the algo class instance attribute' do
      subject
      expect(config.algo).to eq('HS256')
    end
  end

  describe '#set_secret' do
    subject { config.set_secret('secret') }

    it 'sets the secret class instance attribute' do
      subject
      expect(config.secret).to eq('secret')
    end
  end

  describe '#set_finder_method' do
    subject { config.set_finder_method(finder_method) }

    context 'with a callable object or a lambda' do
      let(:finder_method) { ->(id) { { id: id } } }

      it 'sets the finder method class instance attribute' do
        subject
        expect(config.finder_method).to eq(finder_method)
      end
    end

    context 'with an invalid finder method' do
      let(:finder_method) { 'hello' }

      it 'raises an exception' do
        expect { subject }.to raise_error(EasyJwtAuth::InvalidFinderMethod)
      end
    end
  end
end
