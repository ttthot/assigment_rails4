## Rails 7.2.2.1 (December 10, 2024)

- No changes.

## Rails 7.2.2 (October 30, 2024)

- No changes.

## Rails 7.2.1.2 (October 23, 2024)

- No changes.

## Rails 7.2.1.1 (October 15, 2024)

- No changes.

## Rails 7.2.1 (August 22, 2024)

- No changes.

## Rails 7.2.0 (August 09, 2024)

- All tests now respect the `active_job.queue_adapter` config.

  Previously if you had set `config.active_job.queue_adapter` in your `config/application.rb`
  or `config/environments/test.rb` file, the adapter you selected was previously not used consistently
  across all tests. In some tests your adapter would be used, but other tests would use the `TestAdapter`.

  In Rails 7.2, all tests will respect the `queue_adapter` config if provided. If no config is provided,
  the `TestAdapter` will continue to be used.

  See [#48585](https://github.com/rails/rails/pull/48585) for more details.

  _Alex Ghiculescu_

- Make Active Job transaction aware when used conjointly with Active Record.

  A common mistake with Active Job is to enqueue jobs from inside a transaction,
  causing them to potentially be picked and ran by another process, before the
  transaction is committed, which may result in various errors.

  ```ruby
  Topic.transaction do
    topic = Topic.create(...)
    NewTopicNotificationJob.perform_later(topic)
  end
  ```

  Now Active Job will automatically defer the enqueuing to after the transaction is committed,
  and drop the job if the transaction is rolled back.

  Various queue implementations can choose to disable this behavior, and users can disable it,
  or force it on a per job basis:

  ```ruby
  class NewTopicNotificationJob < ApplicationJob
    self.enqueue_after_transaction_commit = :never # or `:always` or `:default`
  end
  ```

  _Jean Boussier_, _Cristian Bica_

- Do not trigger immediate loading of `ActiveJob::Base` when loading `ActiveJob::TestHelper`.

  _Maxime Réty_

- Preserve the serialized timezone when deserializing `ActiveSupport::TimeWithZone` arguments.

  _Joshua Young_

- Remove deprecated `:exponentially_longer` value for the `:wait` in `retry_on`.

  _Rafael Mendonça França_

- Remove deprecated support to set numeric values to `scheduled_at` attribute.

  _Rafael Mendonça França_

- Deprecate `Rails.application.config.active_job.use_big_decimal_serialize`.

  _Rafael Mendonça França_

- Remove deprecated primitive serializer for `BigDecimal` arguments.

  _Rafael Mendonça França_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/activejob/CHANGELOG.md) for previous changes.
