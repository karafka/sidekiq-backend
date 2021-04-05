# Karafka Sidekiq Backend

## Unreleased
- Remove Ruby 2.5 support and update minimum Ruby requirement to 2.6

## 1.4.1 (2020-27-10)
- Corrected interchanger documentation (Jack12816)
- Corrected the interchanger key reference (Jack12816)

## 1.4.0 (2020-09-05)
- Update to match Karafka 1.4.0 params and batch metadata setup

## 1.3.1 (2020-04-27)
- Ruby 2.6.5 support
- Ruby 2.7.1 support
- Change license to LGPL-3.0

## 1.3.0 (2019-09-09)
- Drop Ruby 2.4 support

## 1.3.0.rc1 (2019-07-31)
- Ruby 2.6.3 support
- Drop Ruby 2.3 support
- Sync with Karafka: metadata support
- Sync with Karafka #463 (Split parsers into serializers / deserializers)
- #26 - Make listeners as instances
- Zeitwerk integration
- drop jruby support

## 1.2.0
- ```#load``` and ```#parse``` are renamed to ```#encode``` and ```#decode``` in interchangers
- #274 - Rename controllers to consumers
- Karafka 1.2 support

## 1.1
- Ruby 2.4.2 support
- #235 - Rename perform to consume
- Karafka 1.1 support
- Ruby 2.5.0 support

## 1.0

- Gem init
