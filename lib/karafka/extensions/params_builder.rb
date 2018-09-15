# frozen_string_literal: true

module Karafka
  module Extensions
    module ParamsBuilder
      def from_hash(hash, topic)
        Karafka::Params::Params.new
          .merge!(hash)
          .merge!('parser' => topic.parser)
      end
    end
  end
end

Karafka::Params::Builders::Params.extend Karafka::Extensions::ParamsBuilder
