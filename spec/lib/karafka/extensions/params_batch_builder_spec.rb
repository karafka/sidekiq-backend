# frozen_string_literal: true

RSpec.describe Karafka::Extensions::ParamsBatchBuilder do
  describe '#from_array' do
    subject(:params_batch) { Karafka::Params::Builders::ParamsBatch.from_array(array, topic) }

    let(:hash) { { 'key' => rand } }
    let(:array) { [hash] }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { is_expected.to be_a(Karafka::Params::ParamsBatch) }

    it 'expect to build params batch with params inside' do
      expect(params_batch.to_a.first).to be_a(Karafka::Params::Params)
    end
  end
end
