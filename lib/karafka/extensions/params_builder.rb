# frozen_string_literal: true

module Karafka
  module Extensions
    # Extension for rebuilding params from a hash
    module ParamsBuilder
      # Builds params from a hash
      # @param hash [Hash] hash with params details
      # @param topic [Karafka::Routing::Topic] topic for which we build the params
      # @return [Karafka::Params::Params] built params
      def from_hash(hash, topic)
        metadata = Karafka::Params::Metadata.new(
          **(
            hash
            .fetch('metadata')
            .merge('deserializer' => topic.deserializer)
            .transform_keys(&:to_sym)
          )
        ).freeze

        Karafka::Params::Params
          .new(hash.fetch('raw_payload'), metadata)
      end
    end
  end
end
