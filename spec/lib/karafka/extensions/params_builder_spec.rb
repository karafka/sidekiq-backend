# frozen_string_literal: true

RSpec.describe Karafka::Extensions::ParamsBuilder do
  describe '#from_hash' do
    subject(:params) { Karafka::Params::Builders::Params.from_hash(hash, topic) }

    let(:hash) { { 'raw_payload' => rand, 'metadata' => { 'partition' => 1 } } }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { expect(params.metadata.deserializer).to eq topic.deserializer }
    it { expect(params.metadata.partition).to eq 1 }
    it { expect(params.raw_payload).to eq hash['raw_payload'] }
    it { is_expected.to be_a(Karafka::Params::Params) }
  end
end
