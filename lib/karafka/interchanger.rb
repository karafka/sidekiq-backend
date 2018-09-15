# frozen_string_literal: true

module Karafka
  # Interchangers allow us to format/encode/pack data that is being send to perform_async
  # This is meant to target mostly issues with data encoding like this one:
  # https://github.com/mperham/sidekiq/issues/197
  # Each custom interchanger should implement following methods:
  #   - encode - it is meant to encode params before they get stored inside Redis
  #   - decode - decoded params back to a hash format that we can use
  #
  # This interchanger uses default Sidekiq options to exchange data
  class Interchanger
    class << self
      def encode(data)
        data.is_a?(Params::ParamsBatch) ? data.to_a : data.to_h
      end

      def decode(data)
        data
      end
    end
  end
end
