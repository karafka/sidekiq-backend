
module Extensions
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

module Karafka::AttributesMap
  prepend Extensions
end
