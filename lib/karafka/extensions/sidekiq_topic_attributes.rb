# frozen_string_literal: true

module Karafka
  module Extensions
    # Additional Karafka::Routing::Topic methods that are required to work with Sidekiq backend
    module SidekiqTopicAttributes
      # @return [Class] Class (not an instance) of a worker that should be used to schedule the
      #   background job
      # @note If not provided - will be built based on the provided consumer
      def worker
        @worker ||= backend == :sidekiq ? Karafka::Workers::Builder.new(consumer).build : nil
      end

      # @return [Class] Interchanger class (not an instance) that we want to use to interchange
      #   params between Karafka server and Karafka background job
      def interchanger
        @interchanger ||= Karafka::Interchanger.new
      end

      # Creates attributes writers for worker and interchanger, so they can be overwritten
      # @param base [Class] Karafka::Routing::Topic class
      def self.included(base)
        base.send :attr_writer, :worker
        base.send :attr_writer, :interchanger
      end
    end
  end
end
