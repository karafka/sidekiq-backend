# frozen_string_literal: true

module Karafka
  # Interchangers allow us to format/encode/pack data that is being send to perform_async
  # This is meant to target mostly issues with data encoding like this one:
  # https://github.com/mperham/sidekiq/issues/197
  # Each custom interchanger should implement following methods:
  #   - encode - it is meant to encode params before they get stored inside Redis
  #   - decode - decoded params back to a hash format that we can use
  #
  # This interchanger is not the fastets but it handles many unusual cases and deals well with
  # more complex Ruby and Rails objects
  class Interchanger
    class << self
      # @param params_batch [Karafka::Params::ParamsBatch] Karafka params batch object
      # @note Params might not be parsed because of lazy loading feature. If you implement your
      #   own interchanger logic, this method needs to return data that can be converted to
      #   json with default Sidekiqs logic
      # @return [String] parsed params batch encoded into a string. There are too many problems
      #   with passing unparsed data from Karafka to Sidekiq, to make it a default. In case you
      #   need this, please implement your own interchanger.
      def encode(params_batch)
        Base64.encode64(Marshal.dump(params_batch.parsed))
      end

      # @param params_batch [String] Encoded params batch string that we use to rebuild params
      # @return [Karafka::Params::ParamsBatch] rebuilt params batch
      def decode(params_batch)
        Marshal.load(Base64.decode64(params_batch))
      end
    end
  end
end
