# frozen_string_literal: true

%w[
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
Karafka::Params::Builders::BatchMetadata.extend(Karafka::Extensions::BatchMetadataBuilder)
Karafka::Routing::Topic.include(Karafka::Extensions::SidekiqTopicAttributes)
Karafka::AttributesMap.prepend(Karafka::Extensions::SidekiqAttributesMap)
Karafka::Instrumentation::StdoutListener.include(Karafka::Extensions::StdoutListener)

# Register internal events for instrumentation
%w[
  backends.sidekiq.process
  backends.sidekiq.base_worker.perform
].each(&Karafka.monitor.method(:register_event))
