# frozen_string_literal: true

RSpec.describe Karafka::Interchanger do
  subject(:interchanger_class) { described_class }

  let(:params_batch) { double }

  describe '#load' do
    it 'expect to return what was provided' do
      expect(interchanger_class.load(params_batch)).to eq params_batch
    end
  end

  describe '#parse' do
    it 'expect to return what was provided' do
      expect(interchanger_class.parse(params_batch)).to eq params_batch
    end
  end
end
