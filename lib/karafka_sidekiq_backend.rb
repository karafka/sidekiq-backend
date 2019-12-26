# frozen_string_literal: true

# delegate should be removed because we don't need it, we just add it because of ruby-kafka
%w[
  delegate
  karafka
  sidekiq
].each(&method(:require))

require_relative 'karafka/errors'

Zeitwerk::Loader
  .for_gem
  .tap { |loader| loader.ignore("#{__dir__}/karafka_sidekiq_backend.rb") }
  .tap { |loader| loader.ignore("#{__dir__}/karafka-sidekiq-backend.rb") }
  .tap(&:setup)
  .tap(&:eager_load)

Karafka::Params::Builders::Params.extend(Karafka::Extensions::ParamsBuilder)
Karafka::Params::Builders::ParamsBatch.extend(Karafka::Extensions::ParamsBatchBuilder)
Karafka::Params::Builders::Metadata.extend(Karafka::Extensions::MetadataBuilder)
Karafka::Routing::Topic.include(Karafka::Extensions::SidekiqTopicAttributes)
Karafka::AttributesMap.prepend(Karafka::Extensions::SidekiqAttributesMap)
Karafka::Instrumentation::StdoutListener.include(Karafka::Extensions::StdoutListener)

# Register internal events for instrumentation
%w[
  backends.sidekiq.process
  backends.sidekiq.base_worker.perform
].each(&Karafka.monitor.method(:register_event))
