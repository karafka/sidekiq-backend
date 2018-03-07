# frozen_string_literal: true

RSpec.describe Karafka::BaseWorker do
  subject(:base_worker) { described_class.new }

  let(:consumer_instance) { consumer.new }
  let(:args) { [rand.to_s, rand] }
  let(:consumer) do
    ClassBuilder.inherit(Karafka::BaseConsumer) do
      def consume
        self
      end
    end
  end

  describe '#perform' do
    before do
      allow(base_worker)
        .to receive(:consumer)
        .and_return(consumer_instance)
    end

    it 'performs consumer action' do
      expect(consumer_instance)
        .to receive(:consume)

      expect { base_worker.perform(*args) }.not_to raise_error
    end
  end

  describe '#consumer' do
    let(:topic_id) { rand.to_s }
    let(:interchanger) { double }
    let(:params_batch) { double }
    let(:interchanged_params) { double }
    let(:topic) do
      instance_double(
        Karafka::Routing::Topic,
        interchanger: interchanger,
        consumer: consumer,
        backend: :sidekiq,
        batch_consuming: false,
        responder: nil,
        parser: nil
      )
    end

    before do
      consumer.topic = topic

      allow(Karafka::Routing::Router)
        .to receive(:find)
        .with(topic_id)
        .and_return(topic)

      allow(consumer)
        .to receive(:new)
        .and_return(consumer_instance)
    end

    it 'expect to use router to pick consumer, assign params_batch and return' do
      expect(interchanger).to receive(:decode).with(params_batch).and_return(interchanged_params)
      expect(consumer_instance).to receive(:params_batch=).with(interchanged_params)
      expect(base_worker.send(:consumer, topic_id, params_batch)).to eq consumer_instance
    end
  end
end
