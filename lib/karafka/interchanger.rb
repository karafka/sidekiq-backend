# frozen_string_literal: true

module Karafka
  # Interchangers allow us to format/encode/pack data that is being send to perform_async
  # This is meant to target mostly issues with data encoding like this one:
  # https://github.com/mperham/sidekiq/issues/197
  # Each custom interchanger should implement following methods:
  #   - load - it is meant to encode params before they get stored inside Redis
  #   - parse - decoded params back to a hash format that we can use
  class Interchanger
    class << self
      # @param params_batch [Karafka::Params::ParamsBatch] Karafka params batch object
      # @note Params might not be parsed because of lazy loading feature. If you implement your
      #   own interchanger logic, this method needs to return data that can be converted to
      #   json with default Sidekiqs logic
      # @return [Karafka::Params::ParamsBatch] same as input. We assume that our incoming data is
      #   jsonable-safe and we can rely on a direct Sidekiq encoding logic
      def load(params_batch)
        params_batch
      end

      # @param params_batch [Hash] Sidekiqs params that are now a Hash (after they were JSON#parse)
      # @note Since Sidekiq does not like symbols, we restore symbolized keys for system keys, so
      #   everything can work as expected. Keep in mind, that custom data will always be assigned
      #   with string keys per design. To change it, pleasae change this interchanger and create
      #   your own custom parser
      def parse(params_batch)
        params_batch.map! do |params|
          Karafka::Params::Params::SYSTEM_KEYS.each do |key|
            stringified_key = key.to_s
            params[key] = params.delete(stringified_key) if params.key?(stringified_key)
          end

          params
        end

        params_batch
      end
    end
  end
end
