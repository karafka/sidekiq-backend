# frozen_string_literal: true

RSpec.describe Karafka::Interchanger do
  subject(:interchanger_class) { described_class }

  let(:parsed_params_batch) do
    [
      {
        'value' => 1,
        'parser' => Class,
        'receive_time' => 1,
        'a' => 1
      }
    ]
  end
  let(:params_batch) do
    instance_double(
      Karafka::Params::ParamsBatch,
      parsed: parsed_params_batch
    )
  end

  describe 'encode and decode chain' do
    it 'expects to be able to encode and decode and remain structure' do
      encoded = described_class.encode(params_batch)
      decoded = described_class.decode(encoded)
      expect(decoded).to eq parsed_params_batch
    end
  end
end
