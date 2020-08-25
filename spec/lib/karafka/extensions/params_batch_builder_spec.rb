# frozen_string_literal: true

RSpec.describe Karafka::Extensions::ParamsBatchBuilder do
  describe '#from_array' do
    subject(:params_batch) { Karafka::Params::Builders::ParamsBatch.from_array(array, topic) }

    let(:hash) { { 'raw_payload' => rand, 'metadata' => { 'partition' => 1 } } }
    let(:array) { [hash] }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { is_expected.to be_a(Karafka::Params::ParamsBatch) }

    it 'expect to build params batch with params inside' do
      expect(params_batch.first).to be_a(Karafka::Params::Params)
    end
  end
end
