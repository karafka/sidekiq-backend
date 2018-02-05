# frozen_string_literal: true

RSpec.describe Karafka::Backends::Sidekiq do
  subject(:consumer) { consumer_class.new }

  let(:consumer_class) { Class.new(Karafka::BaseConsumer) }
  let(:interchanger) { Karafka::Interchanger }
  let(:params_batch) { [{ value: rand.to_s }] }
  let(:interchanged_data) { params_batch }
  let(:topic) do
    instance_double(
      Karafka::Routing::Topic,
      id: rand.to_s,
      interchanger: interchanger,
      backend: :sidekiq,
      batch_consuming: true,
      responder: nil,
      parser: nil,
      worker: Class.new(Karafka::BaseWorker)
    )
  end

  before do
    consumer_class.include(described_class)
    consumer_class.topic = topic
    consumer.params_batch = params_batch

    allow(interchanger)
      .to receive(:load)
      .with(consumer.send(:params_batch).to_a)
      .and_return(interchanged_data)
  end

  it 'expect to schedule with sidekiq using interchanged data' do
    expect(topic.worker).to receive(:perform_async)
      .with(topic.id, interchanged_data)
    consumer.call
  end
end
