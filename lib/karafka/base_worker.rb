# frozen_string_literal: true

module Karafka
  # Worker wrapper for Sidekiq workers
  class BaseWorker
    include Sidekiq::Worker

    # Executes the logic that lies in #perform Karafka consumer method
    # @param topic_id [String] Unique topic id that we will use to find a proper topic
    # @param params_batch [Array] Array with messages batch
    def perform(topic_id, params_batch)
      consumer = consumer(topic_id, params_batch)

      Karafka.monitor.instrument(
        'backends.sidekiq.base_worker.perform',
        caller: self,
        consumer: consumer
      ) { consumer.consume }
    end

    private

    # @return [Karafka::Consumer] descendant of Karafka::BaseConsumer that matches the topic
    #   with params_batch assigned already (consumer is ready to use)
    def consumer(topic_id, params_batch)
      topic = Karafka::Routing::Router.find(topic_id)
      consumer = topic.consumer.new
      consumer.params_batch = topic.interchanger.parse(params_batch)
      consumer
    end
  end
end
