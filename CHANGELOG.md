# Karafka Sidekiq Backend

## 1.4.7 (Unreleased)
- Serialize timestamps as strings to prevent Sidekiq warnings (#135)
- Add `documentation_uri` and other links

## 1.4.6 (2022-04-17)
- Add `rubygems_mfa_required`

## 1.4.5 (2022-03-14)
- Fix Hash#except usage (barthez)

## 1.4.4 (2022-03-06)
- Ruby 3.1 support
- Drop support for Ruby 2.6
- Fix unsafe JSON serialization issued by Sidekiq (#122)
- Provide sub-second precision for data processed in Sidekiq

## 1.4.3 (2021-12-05)
- Source code metadata url added to the gemspec

## 1.4.2 (2021-04-21)
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
