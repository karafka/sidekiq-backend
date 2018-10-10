# frozen_string_literal: true

RSpec.describe Karafka::Extensions::SidekiqTopicAttributes do
  subject(:topic) { Karafka::Routing::Topic.new(name, consumer_group) }

  let(:consumer_group) { instance_double(Karafka::Routing::ConsumerGroup, id: group_id) }
  let(:name) { :test }
  let(:group_id) { rand.to_s }
  let(:consumer) { Class.new(Karafka::BaseConsumer) }

  before do
    topic.consumer = consumer
    topic.backend = :inline
  end

  describe '#build' do
    # backend and name are defined always automatically
    (Karafka::AttributesMap.topic - %i[name backend]).each do |attr|
      context "for #{attr}" do
        let(:attr_value) { attr == :backend ? :inline : rand.to_s }

        it 'expect to invoke it and store' do
          expect(topic.instance_variable_defined?(:"@#{attr}")).to be false
          topic.build
          expect(topic.instance_variable_defined?(:"@#{attr}")).to be true
        end
      end
    end
  end

  describe '#worker' do
    before do
      topic.worker = worker
      topic.consumer = consumer
    end

    context 'when backend is inline' do
      let(:worker) { false }

      before do
        topic.backend = :inline
      end

      it { expect(topic.worker).to eq nil }
    end

    context 'when backend is sidekiq' do
      before do
        topic.backend = :sidekiq
      end

      context 'when worker is not set' do
        let(:worker) { nil }
        let(:built_worker) { double }
        let(:builder) { double }

        it 'expect to build worker using builder' do
          expect(Karafka::Workers::Builder).to receive(:new).with(consumer).and_return(builder)
          expect(builder).to receive(:build).and_return(built_worker)
          expect(topic.worker).to eq built_worker
        end
      end
    end

    context 'when worker is set' do
      let(:worker) { double }

      it { expect(topic.worker).to eq worker }
    end
  end

  describe '#interchanger=' do
    let(:interchanger) { double }

    it { expect { topic.interchanger = interchanger }.not_to raise_error }
  end

  describe '#interchanger' do
    before { topic.interchanger = interchanger }

    context 'when interchanger is not set' do
      let(:interchanger) { nil }

      it 'expect to use default one' do
        expect(topic.interchanger).to be_a Karafka::Interchanger
      end
    end

    context 'when interchanger is set' do
      let(:interchanger) { double }

      it { expect(topic.interchanger).to eq interchanger }
    end
  end

  describe '#to_h' do
    it 'expect to contain all the topic map attributes plus id and consumer' do
      expected = (Karafka::AttributesMap.topic + %i[id consumer]).sort
      expect(topic.to_h.keys.sort).to eq(expected)
    end
  end
end
