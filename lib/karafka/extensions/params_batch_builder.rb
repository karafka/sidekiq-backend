# frozen_string_literal: true

module Karafka
  module Extensions
    # Extension for params batch builder for reconstruction of the batch from an array
    module ParamsBatchBuilder
      # Builds params batch from array of hashes
      # @param array [Array<Hash>] array with hash messages
      # @param topic [Karafka::Routing::Topic] topic for which we build the batch
      # @return [Karafka::Params::ParamsBatch] built batch
      # @note We rebuild the params batch from array after the serialization
      def from_array(array, topic)
        params_array = array.map! do |hash|
          Karafka::Params::Builders::Params.from_hash(hash, topic)
        end

        Karafka::Params::ParamsBatch.new(params_array)
      end
    end
  end
end
