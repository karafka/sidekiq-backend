# frozen_string_literal: true

RSpec.describe Karafka::Interchanger do
  subject(:interchanger_class) { described_class }

  let(:params_batch) do
    [
      {
        'value' => 1,
        'parser' => Class,
        'receive_time' => 1,
        'a' => 1
      }
    ]
  end

  describe '#load' do
    it 'expect to return what was provided' do
      expect(interchanger_class.load(params_batch)).to eq params_batch
    end
  end

  describe '#parse' do
    let(:parsed_params_batch) do
      [
        {
          'a' => 1,
          parser: Class,
          value: 1,
          receive_time: 1
        }
      ]
    end

    it 'expect to return what was provided with symbolized system keys' do
      expect(interchanger_class.parse(params_batch)).to eq parsed_params_batch
    end
  end
end
