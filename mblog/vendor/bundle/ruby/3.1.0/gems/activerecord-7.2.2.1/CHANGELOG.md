## Rails 7.2.2.1 (December 10, 2024)

- No changes.

## Rails 7.2.2 (October 30, 2024)

- Fix support for `query_cache: false` in `database.yml`.

  `query_cache: false` would no longer entirely disable the Active Record query cache.

  _zzak_

- Set `.attributes_for_inspect` to `:all` by default.

  For new applications it is set to `[:id]` in config/environment/production.rb.

  In the console all the attributes are always shown.

  _Andrew Novoselac_

- `PG::UnableToSend: no connection to the server` is now retryable as a connection-related exception

  _Kazuma Watanabe_

- Fix marshalling of unsaved associated records in 7.1 format.

  The 7.1 format would only marshal associated records if the association was loaded.
  But associations that would only contain unsaved records would be skipped.

  _Jean Boussier_

- Fix incorrect SQL query when passing an empty hash to `ActiveRecord::Base.insert`.

  _David Stosik_

- Allow to save records with polymorphic join tables that have `inverse_of`
  specified.

  _Markus Doits_

- Fix association scopes applying on the incorrect join when using a polymorphic `has_many through:`.

  _Joshua Young_

- Fix `dependent: :destroy` for bi-directional has one through association.

  Fixes #50948.

  ```ruby
  class Left < ActiveRecord::Base
    has_one :middle, dependent: :destroy
    has_one :right, through: :middle
  end

  class Middle < ActiveRecord::Base
    belongs_to :left, dependent: :destroy
    belongs_to :right, dependent: :destroy
  end

  class Right < ActiveRecord::Base
    has_one :middle, dependent: :destroy
    has_one :left, through: :middle
  end
  ```

  In the above example `left.destroy` wouldn't destroy its associated `Right`
  record.

  _Andy Stewart_

- Properly handle lazily pinned connection pools.

  Fixes #53147.

  When using transactional fixtures with system tests to similar tools
  such as capybara, it could happen that a connection end up pinned by the
  server thread rather than the test thread, causing
  `"Cannot expire connection, it is owned by a different thread"` errors.

  _Jean Boussier_

- Fix `ActiveRecord::Base.with` to accept more than two sub queries.

  Fixes #53110.

  ```ruby
  User.with(foo: [User.select(:id), User.select(:id), User.select(:id)]).to_sql
  undefined method `union' for an instance of Arel::Nodes::UnionAll (NoMethodError)
  ```

  The above now works as expected.

  _fatkodima_

- Properly release pinned connections with non joinable connections.

  Fixes #52973

  When running system tests with transactional fixtures on, it could happen that
  the connection leased by the Puma thread wouldn't be properly released back to the pool,
  causing "Cannot expire connection, it is owned by a different thread" errors in later tests.

  _Jean Boussier_

- Make Float distinguish between `float4` and `float8` in PostgreSQL.

  Fixes #52742

  _Ryota Kitazawa_, _Takayuki Nagatomi_

- Fix an issue where `.left_outer_joins` used with multiple associations that have
  the same child association but different parents does not join all parents.

  Previously, using `.left_outer_joins` with the same child association would only join one of the parents.

  Now it will correctly join both parents.

  Fixes #41498.

  _Garrett Blehm_

- Ensure `ActiveRecord::Encryption.config` is always ready before access.

  Previously, `ActiveRecord::Encryption` configuration was deferred until `ActiveRecord::Base`
  was loaded. Therefore, accessing `ActiveRecord::Encryption.config` properties before
  `ActiveRecord::Base` was loaded would give incorrect results.

  `ActiveRecord::Encryption` now has its own loading hook so that its configuration is set as
  soon as needed.

  When `ActiveRecord::Base` is loaded, even lazily, it in turn triggers the loading of
  `ActiveRecord::Encryption`, thus preserving the original behavior of having its config ready
  before any use of `ActiveRecord::Base`.

  _Maxime Réty_

- Add `TimeZoneConverter#==` method, so objects will be properly compared by
  their type, scale, limit & precision.

  Address #52699.

  _Ruy Rocha_

## Rails 7.2.1.2 (October 23, 2024)

- No changes.

## Rails 7.2.1.1 (October 15, 2024)

- No changes.

## Rails 7.2.1 (August 22, 2024)

- Fix detection for `enum` columns with parallelized tests and PostgreSQL.

  _Rafael Mendonça França_

- Allow to eager load nested nil associations.

  _fatkodima_

- Fix swallowing ignore order warning when batching using `BatchEnumerator`.

  _fatkodima_

- Fix memory bloat on the connection pool when using the Fiber `IsolatedExecutionState`.

  _Jean Boussier_

- Restore inferred association class with the same modularized name.

  _Justin Ko_

- Fix `ActiveRecord::Base.inspect` to properly explain how to load schema information.

  _Jean Boussier_

- Check invalid `enum` options for the new syntax.

  The options using `_` prefix in the old syntax are invalid in the new syntax.

  _Rafael Mendonça França_

- Fix `ActiveRecord::Encryption::EncryptedAttributeType#type` to return
  actual cast type.

  _Vasiliy Ermolovich_

- Fix `create_table` with `:auto_increment` option for MySQL adapter.

  _fatkodima_

## Rails 7.2.0 (August 09, 2024)

- Handle commas in Sqlite3 default function definitions.

  _Stephen Margheim_

- Fixes `validates_associated` raising an exception when configured with a
  singular association and having `index_nested_attribute_errors` enabled.

  _Martin Spickermann_

- The constant `ActiveRecord::ImmutableRelation` has been deprecated because
  we want to reserve that name for a stronger sense of "immutable relation".
  Please use `ActiveRecord::UnmodifiableRelation` instead.

  _Xavier Noria_

- Add condensed `#inspect` for `ConnectionPool`, `AbstractAdapter`, and
  `DatabaseConfig`.

  _Hartley McGuire_

- Fixed a memory performance issue in Active Record attribute methods definition.

  _Jean Boussier_

- Define the new Active Support notification event `start_transaction.active_record`.

  This event is fired when database transactions or savepoints start, and
  complements `transaction.active_record`, which is emitted when they finish.

  The payload has the transaction (`:transaction`) and the connection (`:connection`).

  _Xavier Noria_

- Fix an issue where the IDs reader method did not return expected results
  for preloaded associations in models using composite primary keys.

  _Jay Ang_

- The payload of `sql.active_record` Active Support notifications now has the current transaction in the `:transaction` key.

  _Xavier Noria_

- The payload of `transaction.active_record` Active Support notifications now has the transaction the event is related to in the `:transaction` key.

  _Xavier Noria_

- Define `ActiveRecord::Transaction#uuid`, which returns a UUID for the database transaction. This may be helpful when tracing database activity. These UUIDs are generated only on demand.

  _Xavier Noria_

- Fix inference of association model on nested models with the same demodularized name.

  E.g. with the following setup:

  ```ruby
  class Nested::Post < ApplicationRecord
    has_one :post, through: :other
  end
  ```

  Before, `#post` would infer the model as `Nested::Post`, but now it correctly infers `Post`.

  _Joshua Young_

- PostgreSQL `Cidr#change?` detects the address prefix change.

  _Taketo Takashima_

- Change `BatchEnumerator#destroy_all` to return the total number of affected rows.

  Previously, it always returned `nil`.

  _fatkodima_

- Support `touch_all` in batches.

  ```ruby
  Post.in_batches.touch_all
  ```

  _fatkodima_

- Add support for `:if_not_exists` and `:force` options to `create_schema`.

  _fatkodima_

- Fix `index_errors` having incorrect index in association validation errors.

  _lulalala_

- Add `index_errors: :nested_attributes_order` mode.

  This indexes the association validation errors based on the order received by nested attributes setter, and respects the `reject_if` configuration. This enables API to provide enough information to the frontend to map the validation errors back to their respective form fields.

  _lulalala_

- Add `Rails.application.config.active_record.postgresql_adapter_decode_dates` to opt out of decoding dates automatically with the postgresql adapter. Defaults to true.

  _Joé Dupuis_

- Association option `query_constraints` is deprecated in favor of `foreign_key`.

  _Nikita Vasilevsky_

- Add `ENV["SKIP_TEST_DATABASE_TRUNCATE"]` flag to speed up multi-process test runs on large DBs when all tests run within default transaction.

  This cuts ~10s from the test run of HEY when run by 24 processes against the 178 tables, since ~4,000 table truncates can then be skipped.

  _DHH_

- Added support for recursive common table expressions.

  ```ruby
  Post.with_recursive(
    post_and_replies: [
      Post.where(id: 42),
      Post.joins('JOIN post_and_replies ON posts.in_reply_to_id = post_and_replies.id'),
    ]
  )
  ```

  Generates the following SQL:

  ```sql
  WITH RECURSIVE "post_and_replies" AS (
    (SELECT "posts".* FROM "posts" WHERE "posts"."id" = 42)
    UNION ALL
    (SELECT "posts".* FROM "posts" JOIN post_and_replies ON posts.in_reply_to_id = post_and_replies.id)
  )
  SELECT "posts".* FROM "posts"
  ```

  _ClearlyClaire_

- `validate_constraint` can be called in a `change_table` block.

  ex:

  ```ruby
  change_table :products do |t|
    t.check_constraint "price > discounted_price", name: "price_check", validate: false
    t.validate_check_constraint "price_check"
  end
  ```

  _Cody Cutrer_

- `PostgreSQLAdapter` now decodes columns of type date to `Date` instead of string.

  Ex:

  ```ruby
  ActiveRecord::Base.connection
       .select_value("select '2024-01-01'::date").class #=> Date
  ```

  _Joé Dupuis_

- Strict loading using `:n_plus_one_only` does not eagerly load child associations.

  With this change, child associations are no longer eagerly loaded, to
  match intended behavior and to prevent non-deterministic order issues caused
  by calling methods like `first` or `last`. As `first` and `last` don't cause
  an N+1 by themselves, calling child associations will no longer raise.
  Fixes #49473.

  Before:

  ```ruby
  person = Person.find(1)
  person.strict_loading!(mode: :n_plus_one_only)
  person.posts.first
  # SELECT * FROM posts WHERE person_id = 1; -- non-deterministic order
  person.posts.first.firm # raises ActiveRecord::StrictLoadingViolationError
  ```

  After:

  ```ruby
  person = Person.find(1)
  person.strict_loading!(mode: :n_plus_one_only)
  person.posts.first # this is 1+1, not N+1
  # SELECT * FROM posts WHERE person_id = 1 ORDER BY id LIMIT 1;
  person.posts.first.firm # no longer raises
  ```

  _Reid Lynch_

- Allow `Sqlite3Adapter` to use `sqlite3` gem version `2.x`.

  _Mike Dalessio_

- Allow `ActiveRecord::Base#pluck` to accept hash values.

  ```ruby
  # Before
  Post.joins(:comments).pluck("posts.id", "comments.id", "comments.body")

  # After
  Post.joins(:comments).pluck(posts: [:id], comments: [:id, :body])
  ```

  _fatkodima_

- Raise an `ActiveRecord::ActiveRecordError` error when the MySQL database returns an invalid version string.

  _Kevin McPhillips_

- `ActiveRecord::Base.transaction` now yields an `ActiveRecord::Transaction` object.

  This allows to register callbacks on it.

  ```ruby
  Article.transaction do |transaction|
    article.update(published: true)
    transaction.after_commit do
      PublishNotificationMailer.with(article: article).deliver_later
    end
  end
  ```

  _Jean Boussier_

- Add `ActiveRecord::Base.current_transaction`.

  Returns the current transaction, to allow registering callbacks on it.

  ```ruby
  Article.current_transaction.after_commit do
    PublishNotificationMailer.with(article: article).deliver_later
  end
  ```

  _Jean Boussier_

- Add `ActiveRecord.after_all_transactions_commit` callback.

  Useful for code that may run either inside or outside a transaction and needs
  to perform work after the state changes have been properly persisted.

  ```ruby
  def publish_article(article)
    article.update(published: true)
    ActiveRecord.after_all_transactions_commit do
      PublishNotificationMailer.with(article: article).deliver_later
    end
  end
  ```

  In the above example, the block is either executed immediately if called outside
  of a transaction, or called after the open transaction is committed.

  If the transaction is rolled back, the block isn't called.

  _Jean Boussier_

- Add the ability to ignore counter cache columns until they are backfilled.

  Starting to use counter caches on existing large tables can be troublesome, because the column
  values must be backfilled separately of the column addition (to not lock the table for too long)
  and before the use of `:counter_cache` (otherwise methods like `size`/`any?`/etc, which use
  counter caches internally, can produce incorrect results). People usually use database triggers
  or callbacks on child associations while backfilling before introducing a counter cache
  configuration to the association.

  Now, to safely backfill the column, while keeping the column updated with child records added/removed, use:

  ```ruby
  class Comment < ApplicationRecord
    belongs_to :post, counter_cache: { active: false }
  end
  ```

  While the counter cache is not "active", the methods like `size`/`any?`/etc will not use it,
  but get the results directly from the database. After the counter cache column is backfilled, simply
  remove the `{ active: false }` part from the counter cache definition, and it will now be used by the
  mentioned methods.

  _fatkodima_

- Retry known idempotent SELECT queries on connection-related exceptions.

  SELECT queries we construct by walking the Arel tree and / or with known model attributes
  are idempotent and can safely be retried in the case of a connection error. Previously,
  adapters such as `TrilogyAdapter` would raise `ActiveRecord::ConnectionFailed: Trilogy::EOFError`
  when encountering a connection error mid-request.

  _Adrianna Chang_

- Allow association's `foreign_key` to be composite.

  `query_constraints` option was the only way to configure a composite foreign key by passing an `Array`.
  Now it's possible to pass an Array value as `foreign_key` to achieve the same behavior of an association.

  _Nikita Vasilevsky_

- Allow association's `primary_key` to be composite.

  Association's `primary_key` can be composite when derived from associated model `primary_key` or `query_constraints`.
  Now it's possible to explicitly set it as composite on the association.

  _Nikita Vasilevsky_

- Add `config.active_record.permanent_connection_checkout` setting.

  Controls whether `ActiveRecord::Base.connection` raises an error, emits a deprecation warning, or neither.

  `ActiveRecord::Base.connection` checkouts a database connection from the pool and keeps it leased until the end of
  the request or job. This behavior can be undesirable in environments that use many more threads or fibers than there
  is available connections.

  This configuration can be used to track down and eliminate code that calls `ActiveRecord::Base.connection` and
  migrate it to use `ActiveRecord::Base.with_connection` instead.

  The default behavior remains unchanged, and there is currently no plans to change the default.

  _Jean Boussier_

- Add dirties option to uncached.

  This adds a `dirties` option to `ActiveRecord::Base.uncached` and
  `ActiveRecord::ConnectionAdapters::ConnectionPool#uncached`.

  When set to `true` (the default), writes will clear all query caches belonging to the current thread.
  When set to `false`, writes to the affected connection pool will not clear any query cache.

  This is needed by Solid Cache so that cache writes do not clear query caches.

  _Donal McBreen_

- Deprecate `ActiveRecord::Base.connection` in favor of `.lease_connection`.

  The method has been renamed as `lease_connection` to better reflect that the returned
  connection will be held for the duration of the request or job.

  This deprecation is a soft deprecation, no warnings will be issued and there is no
  current plan to remove the method.

  _Jean Boussier_

- Deprecate `ActiveRecord::ConnectionAdapters::ConnectionPool#connection`.

  The method has been renamed as `lease_connection` to better reflect that the returned
  connection will be held for the duration of the request or job.

  _Jean Boussier_

- Expose a generic fixture accessor for fixture names that may conflict with Minitest.

  ```ruby
  assert_equal "Ruby on Rails", web_sites(:rubyonrails).name
  assert_equal "Ruby on Rails", fixture(:web_sites, :rubyonrails).name
  ```

  _Jean Boussier_

- Using `Model.query_constraints` with a single non-primary-key column used to raise as expected, but with an
  incorrect error message.

  This has been fixed to raise with a more appropriate error message.

  _Joshua Young_

- Fix `has_one` association autosave setting the foreign key attribute when it is unchanged.

  This behavior is also inconsistent with autosaving `belongs_to` and can have unintended side effects like raising
  an `ActiveRecord::ReadonlyAttributeError` when the foreign key attribute is marked as read-only.

  _Joshua Young_

- Remove deprecated behavior that would rollback a transaction block when exited using `return`, `break` or `throw`.

  _Rafael Mendonça França_

- Deprecate `Rails.application.config.active_record.commit_transaction_on_non_local_return`.

  _Rafael Mendonça França_

- Remove deprecated support to pass `rewhere` to `ActiveRecord::Relation#merge`.

  _Rafael Mendonça França_

- Remove deprecated support to pass `deferrable: true` to `add_foreign_key`.

  _Rafael Mendonça França_

- Remove deprecated support to quote `ActiveSupport::Duration`.

  _Rafael Mendonça França_

- Remove deprecated `#quote_bound_value`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::ConnectionAdapters::ConnectionPool#connection_klass`.

  _Rafael Mendonça França_

- Remove deprecated support to apply `#connection_pool_list`, `#active_connections?`, `#clear_active_connections!`,
  `#clear_reloadable_connections!`, `#clear_all_connections!` and `#flush_idle_connections!` to the connections pools
  for the current role when the `role` argument isn't provided.

  _Rafael Mendonça França_

- Remove deprecated `#all_connection_pools`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::ConnectionAdapters::SchemaCache#data_sources`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::ConnectionAdapters::SchemaCache.load_from`.

  _Rafael Mendonça França_

- Remove deprecated `#all_foreign_keys_valid?` from database adapters.

  _Rafael Mendonça França_

- Remove deprecated support to passing coder and class as second argument to `serialize`.

  _Rafael Mendonça França_

- Remove deprecated support to `ActiveRecord::Base#read_attribute(:id)` to return the custom primary key value.

  _Rafael Mendonça França_

- Remove deprecated `TestFixtures.fixture_path`.

  _Rafael Mendonça França_

- Remove deprecated behavior to support referring to a singular association by its plural name.

  _Rafael Mendonça França_

- Deprecate `Rails.application.config.active_record.allow_deprecated_singular_associations_name`.

  _Rafael Mendonça França_

- Remove deprecated support to passing `SchemaMigration` and `InternalMetadata` classes as arguments to
  `ActiveRecord::MigrationContext`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::Migration.check_pending!` method.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::LogSubscriber.runtime` method.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::LogSubscriber.runtime=` method.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::LogSubscriber.reset_runtime` method.

  _Rafael Mendonça França_

- Remove deprecated support to define `explain` in the connection adapter with 2 arguments.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::ActiveJobRequiredError`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::Base.clear_active_connections!`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::Base.clear_reloadable_connections!`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::Base.clear_all_connections!`.

  _Rafael Mendonça França_

- Remove deprecated `ActiveRecord::Base.flush_idle_connections!`.

  _Rafael Mendonça França_

- Remove deprecated `name` argument from `ActiveRecord::Base.remove_connection`.

  _Rafael Mendonça França_

- Remove deprecated support to call `alias_attribute` with non-existent attribute names.

  _Rafael Mendonça França_

- Remove deprecated `Rails.application.config.active_record.suppress_multiple_database_warning`.

  _Rafael Mendonça França_

- Add `ActiveRecord::Encryption::MessagePackMessageSerializer`.

  Serialize data to the MessagePack format, for efficient storage in binary columns.

  The binary encoding requires around 30% less space than the base64 encoding
  used by the default serializer.

  _Donal McBreen_

- Add support for encrypting binary columns.

  Ensure encryption and decryption pass `Type::Binary::Data` around for binary data.

  Previously encrypting binary columns with the `ActiveRecord::Encryption::MessageSerializer`
  incidentally worked for MySQL and SQLite, but not PostgreSQL.

  _Donal McBreen_

- Deprecated `ENV["SCHEMA_CACHE"]` in favor of `schema_cache_path` in the database configuration.

  _Rafael Mendonça França_

- Add `ActiveRecord::Base.with_connection` as a shortcut for leasing a connection for a short duration.

  The leased connection is yielded, and for the duration of the block, any call to `ActiveRecord::Base.connection`
  will yield that same connection.

  This is useful to perform a few database operations without causing a connection to be leased for the
  entire duration of the request or job.

  _Jean Boussier_

- Deprecate `config.active_record.warn_on_records_fetched_greater_than` now that `sql.active_record`
  notification includes `:row_count` field.

  _Jason Nochlin_

- The fix ensures that the association is joined using the appropriate join type
  (either inner join or left outer join) based on the existing joins in the scope.

  This prevents unintentional overrides of existing join types and ensures consistency in the generated SQL queries.

  Example:

  ```ruby
  # `associated` will use `LEFT JOIN` instead of using `JOIN`
  Post.left_joins(:author).where.associated(:author)
  ```

  _Saleh Alhaddad_

- Fix an issue where `ActiveRecord::Encryption` configurations are not ready before the loading
  of Active Record models, when an application is eager loaded. As a result, encrypted attributes
  could be misconfigured in some cases.

  _Maxime Réty_

- Deprecate defining an `enum` with keyword arguments.

  ```ruby
  class Function > ApplicationRecord
    # BAD
    enum color: [:red, :blue],
         type: [:instance, :class]

    # GOOD
    enum :color, [:red, :blue]
    enum :type, [:instance, :class]
  end
  ```

  _Hartley McGuire_

- Add `config.active_record.validate_migration_timestamps` option for validating migration timestamps.

  When set, validates that the timestamp prefix for a migration is no more than a day ahead of
  the timestamp associated with the current time. This is designed to prevent migrations prefixes
  from being hand-edited to future timestamps, which impacts migration generation and other
  migration commands.

  _Adrianna Chang_

- Properly synchronize `Mysql2Adapter#active?` and `TrilogyAdapter#active?`.

  As well as `disconnect!` and `verify!`.

  This generally isn't a big problem as connections must not be shared between
  threads, but is required when running transactional tests or system tests
  and could lead to a SEGV.

  _Jean Boussier_

- Support `:source_location` tag option for query log tags.

  ```ruby
  config.active_record.query_log_tags << :source_location
  ```

  Calculating the caller location is a costly operation and should be used primarily in development
  (note, there is also a `config.active_record.verbose_query_logs` that serves the same purpose)
  or occasionally on production for debugging purposes.

  _fatkodima_

- Add an option to `ActiveRecord::Encryption::Encryptor` to disable compression.

  Allow compression to be disabled by setting `compress: false`

  ```ruby
    class User
      encrypts :name, encryptor: ActiveRecord::Encryption::Encryptor.new(compress: false)
    end
  ```

  _Donal McBreen_

- Deprecate passing strings to `ActiveRecord::Tasks::DatabaseTasks.cache_dump_filename`.

  A `ActiveRecord::DatabaseConfigurations::DatabaseConfig` object should be passed instead.

  _Rafael Mendonça França_

- Add `row_count` field to `sql.active_record` notification.

  This field returns the amount of rows returned by the query that emitted the notification.

  This metric is useful in cases where one wants to detect queries with big result sets.

  _Marvin Bitterlich_

- Consistently raise an `ArgumentError` when passing an invalid argument to a nested attributes association writer.

  Previously, this would only raise on collection associations and produce a generic error on singular associations.

  Now, it will raise on both collection and singular associations.

  _Joshua Young_

- Fix single quote escapes on default generated MySQL columns.

  MySQL 5.7.5+ supports generated columns, which can be used to create a column that is computed from an expression.

  Previously, the schema dump would output a string with double escapes for generated columns with single quotes in the default expression.

  This would result in issues when importing the schema on a fresh instance of a MySQL database.

  Now, the string will not be escaped and will be valid Ruby upon importing of the schema.

  _Yash Kapadia_

- Fix Migrations with versions older than 7.1 validating options given to
  `add_reference` and `t.references`.

  _Hartley McGuire_

- Add `<role>_types` class method to `ActiveRecord::DelegatedType` so that the delegated types can be introspected.

  _JP Rosevear_

- Make `schema_dump`, `query_cache`, `replica` and `database_tasks` configurable via `DATABASE_URL`.

  This wouldn't always work previously because boolean values would be interpreted as strings.

  e.g. `DATABASE_URL=postgres://localhost/foo?schema_dump=false` now properly disable dumping the schema
  cache.

  _Mike Coutermarsh_, _Jean Boussier_

- Introduce `ActiveRecord::Transactions::ClassMethods#set_callback`.

  It is identical to `ActiveSupport::Callbacks::ClassMethods#set_callback`
  but with support for `after_commit` and `after_rollback` callback options.

  _Joshua Young_

- Make `ActiveRecord::Encryption::Encryptor` agnostic of the serialization format used for encrypted data.

  Previously, the encryptor instance only allowed an encrypted value serialized as a `String` to be passed to the message serializer.

  Now, the encryptor lets the configured `message_serializer` decide which types of serialized encrypted values are supported. A custom serialiser is therefore allowed to serialize `ActiveRecord::Encryption::Message` objects using a type other than `String`.

  The default `ActiveRecord::Encryption::MessageSerializer` already ensures that only `String` objects are passed for deserialization.

  _Maxime Réty_

- Fix `encrypted_attribute?` to take into account context properties passed to `encrypts`.

  _Maxime Réty_

- The object returned by `explain` now responds to `pluck`, `first`,
  `last`, `average`, `count`, `maximum`, `minimum`, and `sum`. Those
  new methods run `EXPLAIN` on the corresponding queries:

  ```ruby
  User.all.explain.count
  # EXPLAIN SELECT COUNT(*) FROM `users`
  # ...

  User.all.explain.maximum(:id)
  # EXPLAIN SELECT MAX(`users`.`id`) FROM `users`
  # ...
  ```

  _Petrik de Heus_

- Fixes an issue where `validates_associated` `:on` option wasn't respected
  when validating associated records.

  _Austen Madden_, _Alex Ghiculescu_, _Rafał Brize_

- Allow overriding SQLite defaults from `database.yml`.

  Any PRAGMA configuration set under the `pragmas` key in the configuration
  file takes precedence over Rails' defaults, and additional PRAGMAs can be
  set as well.

  ```yaml
  database: storage/development.sqlite3
  timeout: 5000
  pragmas:
    journal_mode: off
    temp_store: memory
  ```

  _Stephen Margheim_

- Remove warning message when running SQLite in production, but leave it unconfigured.

  There are valid use cases for running SQLite in production. However, it must be done
  with care, so instead of a warning most users won't see anyway, it's preferable to
  leave the configuration commented out to force them to think about having the database
  on a persistent volume etc.

  _Jacopo Beschi_, _Jean Boussier_

- Add support for generated columns to the SQLite3 adapter.

  Generated columns (both stored and dynamic) are supported since version 3.31.0 of SQLite.
  This adds support for those to the SQLite3 adapter.

  ```ruby
  create_table :users do |t|
    t.string :name
    t.virtual :name_upper, type: :string, as: 'UPPER(name)'
    t.virtual :name_lower, type: :string, as: 'LOWER(name)', stored: true
  end
  ```

  _Stephen Margheim_

- TrilogyAdapter: ignore `host` if `socket` parameter is set.

  This allows to configure a connection on a UNIX socket via `DATABASE_URL`:

  ```
  DATABASE_URL=trilogy://does-not-matter/my_db_production?socket=/var/run/mysql.sock
  ```

  _Jean Boussier_

- Make `assert_queries_count`, `assert_no_queries`, `assert_queries_match`, and
  `assert_no_queries_match` assertions public.

  To assert the expected number of queries are made, Rails internally uses `assert_queries_count` and
  `assert_no_queries`. To assert that specific SQL queries are made, `assert_queries_match` and
  `assert_no_queries_match` are used. These assertions can now be used in applications as well.

  ```ruby
  class ArticleTest < ActiveSupport::TestCase
    test "queries are made" do
      assert_queries_count(1) { Article.first }
    end

    test "creates a foreign key" do
      assert_queries_match(/ADD FOREIGN KEY/i, include_schema: true) do
        @connection.add_foreign_key(:comments, :posts)
      end
    end
  end
  ```

  _Petrik de Heus_, _fatkodima_

- Fix `has_secure_token` calls the setter method on initialize.

  _Abeid Ahmed_

- When using a `DATABASE_URL`, allow for a configuration to map the protocol in the URL to a specific database
  adapter. This allows decoupling the adapter the application chooses to use from the database connection details
  set in the deployment environment.

  ```ruby
  # ENV['DATABASE_URL'] = "mysql://localhost/example_database"
  config.active_record.protocol_adapters.mysql = "trilogy"
  # will connect to MySQL using the trilogy adapter
  ```

  _Jean Boussier_, _Kevin McPhillips_

- In cases where MySQL returns `warning_count` greater than zero, but returns no warnings when
  the `SHOW WARNINGS` query is executed, `ActiveRecord.db_warnings_action` proc will still be
  called with a generic warning message rather than silently ignoring the warning(s).

  _Kevin McPhillips_

- `DatabaseConfigurations#configs_for` accepts a symbol in the `name` parameter.

  _Andrew Novoselac_

- Fix `where(field: values)` queries when `field` is a serialized attribute
  (for example, when `field` uses `ActiveRecord::Base.serialize` or is a JSON
  column).

  _João Alves_

- Make the output of `ActiveRecord::Core#inspect` configurable.

  By default, calling `inspect` on a record will yield a formatted string including just the `id`.

  ```ruby
  Post.first.inspect #=> "#<Post id: 1>"
  ```

  The attributes to be included in the output of `inspect` can be configured with
  `ActiveRecord::Core#attributes_for_inspect`.

  ```ruby
  Post.attributes_for_inspect = [:id, :title]
  Post.first.inspect #=> "#<Post id: 1, title: "Hello, World!">"
  ```

  With `attributes_for_inspect` set to `:all`, `inspect` will list all the record's attributes.

  ```ruby
  Post.attributes_for_inspect = :all
  Post.first.inspect #=> "#<Post id: 1, title: "Hello, World!", published_at: "2023-10-23 14:28:11 +0000">"
  ```

  In `development` and `test` mode, `attributes_for_inspect` will be set to `:all` by default.

  You can also call `full_inspect` to get an inspection with all the attributes.

  The attributes in `attribute_for_inspect` will also be used for `pretty_print`.

  _Andrew Novoselac_

- Don't mark attributes as changed when reassigned to `Float::INFINITY` or
  `-Float::INFINITY`.

  _Maicol Bentancor_

- Support the `RETURNING` clause for MariaDB.

  _fatkodima_, _Nikolay Kondratyev_

- The SQLite3 adapter now implements the `supports_deferrable_constraints?` contract.

  Allows foreign keys to be deferred by adding the `:deferrable` key to the `foreign_key` options.

  ```ruby
  add_reference :person, :alias, foreign_key: { deferrable: :deferred }
  add_reference :alias, :person, foreign_key: { deferrable: :deferred }
  ```

  _Stephen Margheim_

- Add the `set_constraints` helper to PostgreSQL connections.

  ```ruby
  Post.create!(user_id: -1) # => ActiveRecord::InvalidForeignKey

  Post.transaction do
    Post.connection.set_constraints(:deferred)
    p = Post.create!(user_id: -1)
    u = User.create!
    p.user = u
    p.save!
  end
  ```

  _Cody Cutrer_

- Include `ActiveModel::API` in `ActiveRecord::Base`.

  _Sean Doyle_

- Ensure `#signed_id` outputs `url_safe` strings.

  _Jason Meller_

- Add `nulls_last` and working `desc.nulls_first` for MySQL.

  _Tristan Fellows_

- Allow for more complex hash arguments for `order` which mimics `where` in `ActiveRecord::Relation`.

  ```ruby
  Topic.includes(:posts).order(posts: { created_at: :desc })
  ```

  _Myles Boone_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/activerecord/CHANGELOG.md) for previous changes.
