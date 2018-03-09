# frozen_string_literal: true

RSpec.describe Karafka::Extensions::SidekiqAttributesMap do
  subject(:attributes_map) { Karafka::AttributesMap }

  it { expect(attributes_map.topic).to include :interchanger }
  it { expect(attributes_map.topic).to include :worker }
end
