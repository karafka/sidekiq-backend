# frozen_string_literal: true

RSpec.describe Karafka::Extensions::BatchMetadataBuilder do
  describe '#from_hash' do
    subject(:batch_metadata) { Karafka::Params::Builders::BatchMetadata.from_hash(hash, topic) }

    let(:hash) { { 'batch_size' => 2 } }
    let(:topic) { instance_double(Karafka::Routing::Topic, deserializer: Class.new) }

    it { expect(batch_metadata.deserializer).to eq topic.deserializer }
    it { expect(batch_metadata.batch_size).to eq hash['batch_size'] }
    it { is_expected.to be_a(Karafka::Params::BatchMetadata) }
  end
end
