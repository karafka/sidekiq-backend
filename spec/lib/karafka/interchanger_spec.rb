# frozen_string_literal: true

RSpec.describe Karafka::Interchanger do
  subject(:interchanger) { described_class.new }

  let(:array_params_batch) do
    [
      Karafka::Params::Params.new(
        1,
        Karafka::Params::Metadata.new(deserializer: 'Class')
      )
    ]
  end
  let(:params_batch) do
    Karafka::Params::ParamsBatch.new(array_params_batch)
  end

  describe '#encode' do
    subject(:encoded) { described_class.new.encode(params_batch) }

    it { expect(encoded).to be_a(Array) }
    it { expect(encoded[0]).to be_a(Hash) }
    it { expect(encoded[0]['raw_payload']).to eq(array_params_batch.first.raw_payload) }
    it { expect(encoded[0]['metadata']).to eq(array_params_batch.first.metadata.to_h) }
  end

  describe '#decode' do
    subject(:decoded) { described_class.new.decode(encoded) }

    let(:encoded) { described_class.new.encode(params_batch) }

    it { expect(decoded).to eq(encoded) }
  end
end
