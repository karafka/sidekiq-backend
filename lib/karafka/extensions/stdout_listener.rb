# frozen_string_literal: true

module Karafka
  module Extensions
    # Additional methods for listener that listen on instrumentation related to the Sidekiq
    # backend of Karafka
    module StdoutListener
      # Logs info about scheduling of a certain dataset with a Sidekiq backend
      # @param event [Dry::Events::Event] event details including payload
      def on_backends_sidekiq_process(event)
        count = event[:caller].send(:params_batch).to_a.size
        topic = event[:caller].topic.name
        time = event[:time]
        info "Scheduling of #{count} messages to Sidekiq on topic #{topic} took #{time} ms"
      end

      # Logs ino about processing certain events with a given Sidekiq worker
      # @param event [Dry::Events::Event] event details including payload
      def on_backends_sidekiq_base_worker_perform(event)
        count = event[:consumer].send(:params_batch).to_a.size
        topic = event[:consumer].topic.name
        time = event[:time]
        info "Sidekiq processing of topic #{topic} with #{count} messages took #{time} ms"
      end
    end
  end
end
