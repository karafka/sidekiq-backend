# frozen_string_literal: true

RSpec.describe Karafka::AttributesMap do
  subject(:map) { described_class }

  describe '#topic' do
    it { expect(described_class.topic).to include(:worker) }
    it { expect(described_class.topic).to include(:interchanger) }
  end
end
