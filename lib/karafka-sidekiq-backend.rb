# frozen_string_literal: true

%w[
  sidekiq
].each(&method(:require))

module Karafka
  module Backends
    module Sidekiq
      class << self
        # @return [String] path to Karafka gem root core
        def core_root
          Pathname.new(File.expand_path('../karafka', __FILE__))
        end
      end
    end
  end
end

Karafka::Loader.load!(Karafka::Backends::Sidekiq.core_root)
