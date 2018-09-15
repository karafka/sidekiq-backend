# frozen_string_literal: true

module Karafka
  module Extensions
    module ParamsBatchBuilder
      def from_array(array, topic)
        params_array = array.map! do |hash|
          Karafka::Params::Builders::Params.from_hash(hash, topic)
        end

        Karafka::Params::ParamsBatch.new(params_array)
      end
    end
  end
end

Karafka::Params::Builders::ParamsBatch.extend Karafka::Extensions::ParamsBatchBuilder
