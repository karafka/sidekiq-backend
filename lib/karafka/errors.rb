# frozen_string_literal: true

module Karafka
  # Namespace used to encapsulate all the internal errors of Karafka
  module Errors
    # Raised when application does not have ApplicationWorker or other class that directly
    # inherits from Karafka::BaseWorker
    BaseWorkerDescentantMissing = Class.new(BaseError)
  end
end
