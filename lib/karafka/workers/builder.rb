# frozen_string_literal: true

module Karafka
  # Internal stuff related to workers
  module Workers
    # Builder is used to check if there is a proper consumer with the same name as
    # a consumer and if not, it will create a default one using Karafka::BaseWorker
    # This is used as a building layer between consumers and workers. it will be only used
    # when user does not provide his own worker that should perform consumer stuff
    class Builder
      # @param consumer_class [Karafka::BaseConsumer] descendant of Karafka::BaseConsumer
      # @example Create a worker builder
      #   Karafka::Workers::Builder.new(SuperConsumer)
      def initialize(consumer_class)
        @consumer_class = consumer_class
      end

      # @return [Class] Sidekiq worker class that already exists or new build based
      #   on the provided consumer_class name
      # @example Consumer: SuperConsumer
      #   build #=> SuperWorker
      # @example Consumer: Videos::NewVideosConsumer
      #   build #=> Videos::NewVideosWorker
      def build
        return matcher.match if matcher.match

        klass = Class.new(Karafka::BaseWorker.base_worker)
        matcher.scope.const_set(matcher.name, klass)
      end

      private

      # @return [Karafka::Helpers::ClassMatcher] matcher instance for matching between consumer
      #   and appropriate worker
      def matcher
        @matcher ||= Helpers::ClassMatcher.new(
          @consumer_class,
          from: 'Consumer',
          to: 'Worker'
        )
      end
    end
  end
end
