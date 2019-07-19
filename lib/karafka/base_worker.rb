# frozen_string_literal: true

module Karafka
  # Worker wrapper for Sidekiq workers
  class BaseWorker
    include Sidekiq::Worker

    class << self
      # Returns the base worker class for application.
      #
      # @return [Class] first worker that inherited from Karafka::BaseWorker. Karafka
      #   assumes that it is the base worker for an application.
      # @raise [Karafka::Errors::BaseWorkerDescentantMissing] raised when application
      #   base worker was not defined.
      def base_worker
        @inherited || raise(Errors::BaseWorkerDescentantMissing)
      end

      def inherited(subclass)
        @inherited ||= subclass
      end
    end

    # Executes the logic that lies in #perform Karafka consumer method
    # @param topic_id [String] Unique topic id that we will use to find a proper topic
    # @param params_batch [Array<Hash>] Array with messages batch
    # @param metadata [Hash, nil] hash with all the metadata or nil if not present
    def perform(topic_id, params_batch, metadata)
      consumer = consumer(topic_id, params_batch, metadata)

      Karafka.monitor.instrument(
        'backends.sidekiq.base_worker.perform',
        caller: self,
        consumer: consumer
      ) { consumer.consume }
    end

    private

    # @see `#perform` for exact params descriptions
    # @param topic_id [String]
    # @param params_batch [Array<Hash>]
    # @param metadata [Hash, nil]
    # @return [Karafka::Consumer] descendant of Karafka::BaseConsumer that matches the topic
    #   with params_batch assigned already (consumer is ready to use)
    def consumer(topic_id, params_batch, metadata)
      topic = Karafka::Routing::Router.find(topic_id)
      consumer = topic.consumer.new(topic)
      consumer.params_batch = Params::Builders::ParamsBatch.from_array(
        topic.interchanger.decode(params_batch),
        topic
      )

      if topic.batch_fetching
        consumer.metadata = Params::Builders::Metadata.from_hash(
          metadata,
          topic
        )
      end

      consumer
    end
  end
end
