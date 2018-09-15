# frozen_string_literal: true

module Karafka
  module Extensions
    module MetadataBuilder
      def from_hash(hash, topic)
        Karafka::Params::Metadata
          .new
          .merge!(hash)
          .merge!('parser' => topic.parser)
      end
    end
  end
end

Karafka::Params::Builders::Metadata.extend Karafka::Extensions::MetadataBuilder
