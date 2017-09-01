module Karafka
  module Extensions
    module SidekiqAttributesMap
      module ClassMethods
        def topic
          super + %i[interchanger worker]
        end
      end

      def self.prepended(base)
        class << base
          prepend ClassMethods
        end
      end
    end
  end
end

Karafka::AttributesMap.prepend Karafka::Extensions::SidekiqAttributesMap
