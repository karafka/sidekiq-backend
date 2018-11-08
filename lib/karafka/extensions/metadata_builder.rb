# frozen_string_literal: true

module Karafka
  module Extensions
    # Extension for metadata builder to allow building metadata from a hash
    module MetadataBuilder
      # Builds metadata from hash
      # @param hash [Hash] hash with metadata
      # @param topic [Karafka::Routing::Topic] topic instance
      # @return [Karafka::Params::Metadata] metadata instance
      def from_hash(hash, topic)
        # Parser needs to be merged as this is the only non-serializable object
        # so it gets reconstructed from the topic
        Karafka::Params::Metadata
          .new
          .merge!(hash)
          .merge!('parser' => topic.parser)
      end
    end
  end
end
