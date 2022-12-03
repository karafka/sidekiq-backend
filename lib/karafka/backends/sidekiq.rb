# frozen_string_literal: true

module Karafka
  # Namespace for alternative processing backends for Karafka framework
  module Backends
    # Sidekiq backend that schedules stuff to Sidekiq worker for delayed execution
    module Sidekiq
      # Karafka Sidekiq backend version
      VERSION = '1.4.7'

      # Enqueues the execution of perform method into a worker.
      # @note Each worker needs to have a class #perform_async method that will allow us to pass
      #   parameters into it. We always pass topic as a first argument and this request
      #   params_batch as a second one (we pass topic to be able to build back the consumer
      #   in the worker)
      def process
        Karafka.monitor.instrument('backends.sidekiq.process', caller: self) do
          # We add batch metadata only for batch worker
          batch_metadata_hash = if respond_to?(:batch_metadata)
                                  # We remove deserializer as it's not safe to convert it to json
                                  # and we can rebuild it anyhow based on the routing data in the
                                  # worker
                                  batch_metadata.to_h
                                                .transform_keys(&:to_s)
                                                .tap { |h| h.delete('deserializer') }
                                end

          topic.worker.perform_async(
            topic.id,
            topic.interchanger.encode(params_batch),
            batch_metadata_hash
          )
        end
      end
    end
  end
end
