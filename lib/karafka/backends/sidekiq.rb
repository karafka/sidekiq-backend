# frozen_string_literal: true

module Karafka
  # Namespace for alternative processing backends for Karafka framework
  module Backends
    # Sidekiq backend that schedules stuff to Sidekiq worker for delayed execution
    module Sidekiq
      # Karafka Sidekiq backend version
      VERSION = '1.4.0.rc1'

      # Enqueues the execution of perform method into a worker.
      # @note Each worker needs to have a class #perform_async method that will allow us to pass
      #   parameters into it. We always pass topic as a first argument and this request
      #   params_batch as a second one (we pass topic to be able to build back the consumer
      #   in the worker)
      def process
        Karafka.monitor.instrument('backends.sidekiq.process', caller: self) do
          topic.worker.perform_async(
            topic.id,
            topic.interchanger.encode(params_batch),
            respond_to?(:batch_metadata) ? batch_metadata.to_h : nil
          )
        end
      end
    end
  end
end
