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
  # @note Since we use symbols for Karafka params (performance reasons), they will be
  #   deserialized into string versions. Keep that in mind.
  class Interchanger
    class << self
      # @param params_batch [Karafka::Params::ParamsBatch] Karafka params batch object
      # @return [Karafka::Params::ParamsBatch] parsed params batch. There are too many problems
      #   with passing unparsed data from Karafka to Sidekiq, to make it a default. In case you
      #   need this, please implement your own interchanger.
      def encode(params_batch)
        params_batch.parsed
      end

      # @param params_batch [Array<Hash>] Sidekiq params that are now an array
      # @note Since Sidekiq does not like symbols, we restore symbolized keys for system keys, so
      #   everything can work as expected. Keep in mind, that custom data will always be assigned
      #   with string keys per design. To change it, please change this interchanger and create
      #   your own custom parser
      def decode(params_batch)
        params_batch
      end
    end
  end
end
