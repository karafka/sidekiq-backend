# frozen_string_literal: true

module Karafka
  module Extensions
    # Extension for rebuilding params from a hash
    module ParamsBuilder
      # Buils params from a hash
      # @param hash [Hash] hash with params details
      # @param topic [Karafka::Routing::Topic] topic for which we build the params
      # @return [Karafka::Params::Params] built params
      def from_hash(hash, topic)
        Karafka::Params::Params
          .new
          .merge!(hash)
          .merge!('deserializer' => topic.deserializer)
      end
    end
  end
end
