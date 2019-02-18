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
    # @param params_batch [Karafka::Params::ParamsBatch] Karafka params batch object
    # @return [Array<Karafka::Params::Params>] Array with hash/hashwithindiff values that will
    #   be serialized using Sidekiq serialization engine
    def encode(params_batch)
      params_batch.to_a
    end

    # @param params_batch [Array<Hash>] Sidekiq params that are now an array
    # @return [Array<Hash>] exactly what we've fetched from Sidekiq
    def decode(params_batch)
      params_batch
    end
  end
end
