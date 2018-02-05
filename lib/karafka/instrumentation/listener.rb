# frozen_string_literal: true

module Karafka
  module Instrumentation
    # Additional methods for listener that listen on instrumentation related to the Sidekiq
    # backend of Karafka
    class Listener
      class << self
        # Logs info about processing of a certain dataset with an inline backend
        # @param event [Dry::Events::Event] event details including payload
        def on_backends_sidekiq_process(event)
          count = event[:caller].send(:params_batch).to_a.size
          topic = event[:caller].topic.name
          time = event[:time]
          info "Scheduling of #{count} messages to Sidekiq backend on topic #{topic} took #{time} ms"
        end

        def on_backends_sidekiq_base_worker_perform(event)
          count = event[:consumer].send(:params_batch).to_a.size
          topic = event[:consumer].topic.name
          time = event[:time]
          info "Sidekiq backend processing of topic #{topic} with #{count} messages took #{time} ms"
        end
      end
    end
  end
end
