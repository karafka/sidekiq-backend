# frozen_string_literal: true

RSpec.describe Karafka::Interchanger do
  subject(:interchanger) { described_class.new }

  let(:time) { Time.at(111_111_111_1.9999999).to_time }
  let(:array_params_batch) do
    [
      Karafka::Params::Params.new(
        1,
        Karafka::Params::Metadata.new(
          deserializer: 'Class',
          create_time: time,
          receive_time: time
        )
      )
    ]
  end
  let(:params_batch) do
    Karafka::Params::ParamsBatch.new(array_params_batch)
  end

  describe '#encode' do
    subject(:encoded) { described_class.new.encode(params_batch) }

    let(:mapped_metadata) do
      meta = array_params_batch
             .first
             .metadata
             .to_h
             .transform_keys(&:to_s)
             .tap { |hash| hash.delete('deserializer') }

      meta['create_time'] = meta['create_time'].to_f.to_s
      meta['receive_time'] = meta['receive_time'].to_f.to_s

      meta
    end

    it { expect(encoded).to be_a(Array) }
    it { expect(encoded[0]).to be_a(Hash) }
    it { expect(encoded[0]['raw_payload']).to eq(array_params_batch.first.raw_payload) }
    it { expect(encoded[0]['metadata']).to eq(mapped_metadata) }
  end

  describe '#decode' do
    subject(:decoded) { described_class.new.decode(encoded_and_processed) }

    let(:encoded_and_processed) { JSON.load(JSON.dump(encoded)) } # rubocop:disable JSONLoad
    let(:encoded) { described_class.new.encode(params_batch) }

    it { expect(decoded).to eq(encoded_and_processed) }
    it { expect(decoded[0].keys).not_to include('deserializer') }
  end
end
