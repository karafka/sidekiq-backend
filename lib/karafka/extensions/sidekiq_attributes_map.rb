# frozen_string_literal: true

module Karafka
  module Extensions
    # Additional Karafka::Attributes map topic attributes that can be used when worker
    # is active and we use sidekiq backend
    module SidekiqAttributesMap
      # Class methods that extend the attributes map class
      module ClassMethods
        # Extra topic fields that we need to have to work with sidekiq backend
        # @return [Array<Symbol>] available topic options
        def topic
          super + %i[interchanger worker]
        end
      end

      # Prepends class methods into attributes map
      # @param base [Class] class that we prepend to
      def self.prepended(base)
        base.singleton_class.prepend ClassMethods
      end
    end
  end
end
