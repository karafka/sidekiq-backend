# Karafka Sidekiq Backend

## Deprecation notice

This backend was designed to compensate for lack of multi-threading in Karafka. Karafka `2.0` **is** multi-threaded.

We will **still** support it for Karafka `1.4` but it won't work with Karafka `2.0`.

## About

[![Build Status](https://github.com/karafka/sidekiq-backend/workflows/ci/badge.svg)](https://github.com/karafka/sidekiq-backend/actions?query=workflow%3Aci)
[![Gem Version](https://badge.fury.io/rb/karafka-sidekiq-backend.svg)](http://badge.fury.io/rb/karafka-sidekiq-backend)
[![Join the chat at https://slack.karafka.io](https://raw.githubusercontent.com/karafka/misc/master/slack.svg)](https://slack.karafka.io)

[Karafka Sidekiq Backend](https://github.com/karafka/sidekiq-backend) provides support for consuming (processing) received Kafka messages inside of Sidekiq workers.

## Installations

Add this to your gemfile:

```ruby
gem 'karafka-sidekiq-backend'
```

and create a file called ```application_worker.rb``` inside of your ```app/workers``` directory, that looks like that:

```ruby
class ApplicationWorker < Karafka::BaseWorker
end
```

and you are ready to go. Karafka Sidekiq Backend integrates with Karafka automatically

**Note**: You can name your application worker base class with any name you want. The only thing that is required is a direct inheritance from the ```Karafka::BaseWorker``` class.

## Usage

If you want to process messages with Sidekiq backend, you need to tell this to Karafka.

To do so, you can either configure that in a configuration block:

```ruby
class App < Karafka::App
  setup do |config|
    config.backend = :sidekiq
    # Other config options...
  end
end
```

or on a per topic level:

```ruby
App.routes.draw do
  consumer_group :videos_consumer do
    topic :binary_video_details do
      backend :sidekiq
      consumer Videos::DetailsConsumer
      worker Workers::DetailsWorker
      interchanger Interchangers::MyCustomInterchanger.new
    end
  end
end
```

You don't need to do anything beyond that. Karafka will know, that you want to run your consumer's ```#consume``` method in a background job.

## Configuration

There are two options you can set inside of the ```topic``` block:

| Option       | Value type | Description                                                                                                       |
|--------------|------------|-------------------------------------------------------------------------------------------------------------------|
| worker       | Class      | Name of a worker class that we want to use to schedule perform code                                               |
| interchanger | Instance   | Instance of an interchanger class that we want to use to pass the incoming data to Sidekiq                        |


### Workers

Karafka by default will build a worker that will correspond to each of your consumers (so you will have a pair - consumer and a worker). All of them will inherit from ```ApplicationWorker``` and will share all its settings.

To run Sidekiq you should have sidekiq.yml file in *config* folder. The example of ```sidekiq.yml``` file will be generated to config/sidekiq.yml.example once you run ```bundle exec karafka install```.

However, if you want to use a raw Sidekiq worker (without any Karafka additional magic), or you want to use SidekiqPro (or any other queuing engine that has the same API as Sidekiq), you can assign your own custom worker:

```ruby
topic :incoming_messages do
  consumer MessagesConsumer
  worker MyCustomWorker
end
```

Note that even then, you need to specify a consumer that will schedule a background task.

Custom workers need to provide a ```#perform_async``` method. It needs to accept two arguments:

 - ```topic_id``` - first argument is a current topic id from which a given message comes
 - ```params_batch``` - all the params that came from Kafka + additional metadata. This data format might be changed if you use custom interchangers. Otherwise, it will be an instance of Karafka::Params::ParamsBatch.

**Note**: If you use custom interchangers, keep in mind, that params inside params batch might be in two states: parsed or unparsed when passed to #perform_async. This means, that if you use custom interchangers and/or custom workers, you might want to look into Karafka's sources to see exactly how it works.

### Interchangers

Custom interchangers target issues with non-standard (binary, etc.) data that we want to store when we do ```#perform_async```. This data might be corrupted when fetched in a worker (see [this](https://github.com/karafka/karafka/issues/30) issue). With custom interchangers, you can encode/compress data before it is being passed to scheduling and decode/decompress it when it gets into the worker.

To specify the interchanger for a topic, specify the interchanger inside routes like this:

```ruby
App.routes.draw do
  consumer_group :videos_consumer do
    topic :binary_video_details do
      consumer Videos::DetailsConsumer
      interchanger Interchangers::MyCustomInterchanger.new
    end
  end
end
```
Each custom interchanger should define `encode` to encode params before they get stored in Redis, and `decode` to convert the params to hash format, as shown below:

```ruby
class Base64Interchanger < ::Karafka::Interchanger
  def encode(params_batch)
    Base64.encode64(Marshal.dump(super))
  end

  def decode(params_string)
    Marshal.load(Base64.decode64(super))
  end
end

```

**Warning**: if you decide to use slow interchangers, they might significantly slow down Karafka.

## References

* [Karafka framework](https://github.com/karafka/karafka)
* [Karafka Sidekiq Backend Actions CI](https://github.com/karafka/sidekiq-backend/actions?query=workflow%3Aci)
* [Karafka Sidekiq Backend Coditsu](https://app.coditsu.io/karafka/repositories/karafka-sidekiq-backend)

## Note on contributions

First, thank you for considering contributing to the Karafka ecosystem! It's people like you that make the open source community such a great community!

Each pull request must pass all the RSpec specs, integration tests and meet our quality requirements.

Fork it, update and wait for the Github Actions results.
