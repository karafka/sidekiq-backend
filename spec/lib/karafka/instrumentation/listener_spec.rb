# frozen_string_literal: true

RSpec.describe Karafka::Instrumentation::Listener do
  let(:event) { Dry::Events::Event.new(rand, payload) }
  let(:time) { rand }
  let(:topic) { instance_double(Karafka::Routing::Topic, name: topic_name) }
  let(:topic_name) { rand.to_s }

  describe '#on_backends_sidekiq_process' do
    subject(:trigger) { described_class.on_backends_sidekiq_process(event) }

    let(:payload) { { caller: caller, time: time } }
    let(:params_batch) { [1] }
    let(:count) { params_batch.size }
    let(:message) do
      "Scheduling of #{count} messages to Sidekiq on topic #{topic_name} took #{time} ms"
    end
    let(:caller) do
      instance_double(
        Karafka::BaseConsumer,
        params_batch: params_batch,
        topic: topic
      )
    end

    it 'expect logger to log proper message' do
      expect(Karafka.logger).to receive(:info).with(message)
      trigger
    end
  end

  describe '#on_backends_sidekiq_base_worker_perform' do
    subject(:trigger) { described_class.on_backends_sidekiq_base_worker_perform(event) }

    let(:time) { rand }
    let(:payload) { { caller: self, time: time, consumer: consumer } }
    let(:params_batch) { [1] }
    let(:count) { params_batch.size }
    let(:message) do
      "Sidekiq processing of topic #{topic_name} with #{count} messages took #{time} ms"
    end
    let(:consumer) do
      instance_double(
        Karafka::BaseConsumer,
        params_batch: params_batch,
        topic: topic
      )
    end

    it 'expect logger to log proper message' do
      expect(Karafka.logger).to receive(:info).with(message)
      trigger
    end
  end
end
