# frozen_string_literal: true

RSpec.describe Karafka::Errors do
  describe 'BaseWorkerDescentantMissing' do
    subject(:error) { described_class::BaseWorkerDescentantMissing }

    specify { expect(error).to be < described_class::BaseError }
  end
end
