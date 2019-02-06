# frozen_string_literal: true

RSpec.describe Karafka::Extensions::ParamsBuilder do
  describe '#from_hash' do
    subject(:params) { Karafka::Params::Builders::Params.from_hash(hash, topic) }

    let(:hash) { { 'key' => rand } }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { expect(params['deserializer']).to eq topic.deserializer }
    it { expect(params['key']).to eq hash['key'] }
    it { is_expected.to be_a(Karafka::Params::Params) }
  end
end
