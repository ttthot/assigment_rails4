## Rails 7.2.2.1 (December 10, 2024)

- No changes.

## Rails 7.2.2 (October 30, 2024)

- No changes.

## Rails 7.2.1.2 (October 23, 2024)

- No changes.

## Rails 7.2.1.1 (October 15, 2024)

- No changes.

## Rails 7.2.1 (August 22, 2024)

- Fix `rails console` for application with non default application constant.

  The wrongly assumed the Rails application would be named `AppNamespace::Application`,
  which is the default but not an obligation.

  _Jean Boussier_

- Fix the default Dockerfile to include the full sqlite3 package.

  Prior to this it only included `libsqlite3`, so it wasn't enough to
  run `rails dbconsole`.

  _Jerome Dalbert_

- Don't update public directory during `app:update` command for API-only Applications.

  _y-yagi_

- Don't add bin/brakeman if brakeman is not in bundle when upgrading an application.

  _Etienne Barrié_

- Remove PWA views and routes if its an API only project.

  _Jean Boussier_

- Simplify generated Puma configuration

  _DHH_, _Rafael Mendonça França_

## Rails 7.2.0 (August 09, 2024)

- The new `bin/rails boot` command boots the application and exits. Supports the
  standard `-e/--environment` options.

  _Xavier Noria_

- Create a Dev Container Generator that generates a Dev Container setup based on the current configuration
  of the application. Usage:

  `bin/rails devcontainer`

  _Andrew Novoselac_

- Add Rubocop and GitHub Actions to plugin generator.
  This can be skipped using --skip-rubocop and --skip-ci.

  _Chris Oliver_

- Remove support for `oracle`, `sqlserver` and JRuby specific database adapters from the
  `rails new` and `rails db:system:change` commands.

  The supported options are `sqlite3`, `mysql`, `postgresql` and `trilogy`.

  _Andrew Novoselac_

- Add options to `bin/rails app:update`.

  `bin/rails app:update` now supports the same generic options that generators do:

  - `--force`: Accept all changes to existing files
  - `--skip`: Refuse all changes to existing files
  - `--pretend`: Don't make any changes
  - `--quiet`: Don't output all changes made

  _Étienne Barrié_

- Implement Rails console commands and helpers with IRB v1.13's extension APIs.

  Rails console users will now see `helper`, `controller`, `new_session`, and `app` under
  IRB help message's `Helper methods` category. And `reload!` command will be displayed under
  the new `Rails console` commands category.

  Prior to this change, Rails console's commands and helper methods are added through IRB's
  private components and don't show up in its help message, which led to poor discoverability.

  _Stan Lo_

- Remove deprecated `Rails::Generators::Testing::Behaviour`.

  _Rafael Mendonça França_

- Remove deprecated `find_cmd_and_exec` console helper.

  _Rafael Mendonça França_

- Remove deprecated `Rails.config.enable_dependency_loading`.

  _Rafael Mendonça França_

- Remove deprecated `Rails.application.secrets`.

  _Rafael Mendonça França_

- Generated Gemfile will include `require: "debug/prelude"` for the `debug` gem.

  Requiring `debug` gem directly automatically activates it, which could introduce
  additional overhead and memory usage even without entering a debugging session.

  By making Bundler require `debug/prelude` instead, developers can keep their access
  to breakpoint methods like `debugger` or `binding.break`, but the debugger won't be
  activated until a breakpoint is hit.

  _Stan Lo_

- Skip generating a `test` job in ci.yml when a new application is generated with the
  `--skip-test` option.

  _Steve Polito_

- Update the `.node-version` file conditionally generated for new applications to 20.11.1

  _Steve Polito_

- Fix sanitizer vendor configuration in 7.1 defaults.

  In apps where rails-html-sanitizer was not eagerly loaded, the sanitizer default could end up
  being Rails::HTML4::Sanitizer when it should be set to Rails::HTML5::Sanitizer.

  _Mike Dalessio_, _Rafael Mendonça França_

- Set `action_mailer.default_url_options` values in `development` and `test`.

  Prior to this commit, new Rails applications would raise `ActionView::Template::Error`
  if a mailer included a url built with a `*_path` helper.

  _Steve Polito_

- Introduce `Rails::Generators::Testing::Assertions#assert_initializer`.

  Compliments the existing `initializer` generator action.

  ```rb
  assert_initializer "mail_interceptors.rb"
  ```

  _Steve Polito_

- Generate a .devcontainer folder and its contents when creating a new app.

  The .devcontainer folder includes everything needed to boot the app and do development in a remote container.

  The container setup includes:

  - A redis container for Kredis, ActionCable etc.
  - A database (SQLite, Postgres, MySQL or MariaDB)
  - A Headless chrome container for system tests
  - Active Storage configured to use the local disk and with preview features working

  If any of these options are skipped in the app setup they will not be included in the container configuration.

  These files can be skipped using the `--skip-devcontainer` option.

  _Andrew Novoselac & Rafael Mendonça França_

- Introduce `SystemTestCase#served_by` for configuring the System Test application server.

  By default this is localhost. This method allows the host and port to be specified manually.

  ```ruby
  class ApplicationSystemTestCase < ActionDispatch::SystemTestCase
    served_by host: "testserver", port: 45678
  end
  ```

  _Andrew Novoselac & Rafael Mendonça França_

- `bin/rails test` will no longer load files named `*_test.rb` if they are located in the `fixtures` folder.

  _Edouard Chin_

- Ensure logger tags configured with `config.log_tags` are still active in `request.action_dispatch` handlers.

  _KJ Tsanaktsidis_

- Setup jemalloc in the default Dockerfile for memory optimization.

  _Matt Almeida_, _Jean Boussier_

- Commented out lines in .railsrc file should not be treated as arguments when using
  rails new generator command. Update ARGVScrubber to ignore text after `#` symbols.

  _Willian Tenfen_

- Skip CSS when generating APIs.

  _Ruy Rocha_

- Rails console now indicates application name and the current Rails environment:

  ```txt
  my-app(dev)> # for RAILS_ENV=development
  my-app(test)> # for RAILS_ENV=test
  my-app(prod)> # for RAILS_ENV=production
  my-app(my_env)> # for RAILS_ENV=my_env
  ```

  The application name is derived from the application's module name from `config/application.rb`.
  For example, `MyApp` will displayed as `my-app` in the prompt.

  Additionally, the environment name will be colorized when the environment is
  `development` (blue), `test` (blue), or `production` (red), if your
  terminal supports it.

  _Stan Lo_

- Ensure `autoload_paths`, `autoload_once_paths`, `eager_load_paths`, and
  `load_paths` only have directories when initialized from engine defaults.

  Previously, files under the `app` directory could end up there too.

  _Takumasa Ochi_

- Prevent unnecessary application reloads in development.

  Previously, some files outside autoload paths triggered unnecessary reloads.
  With this fix, application reloads according to `Rails.autoloaders.main.dirs`,
  thereby preventing unnecessary reloads.

  _Takumasa Ochi_

- Use `oven-sh/setup-bun` in GitHub CI when generating an app with Bun.

  _TangRufus_

- Disable `pidfile` generation in the `production` environment.

  _Hans Schnedlitz_

- Set `config.action_view.annotate_rendered_view_with_filenames` to `true` in
  the `development` environment.

  _Adrian Marin_

- Support the `BACKTRACE` environment variable to turn off backtrace cleaning.

  Useful for debugging framework code:

  ```sh
  BACKTRACE=1 bin/rails server
  ```

  _Alex Ghiculescu_

- Raise `ArgumentError` when reading `config.x.something` with arguments:

  ```ruby
  config.x.this_works.this_raises true # raises ArgumentError
  ```

  _Sean Doyle_

- Add default PWA files for manifest and service-worker that are served from `app/views/pwa` and can be dynamically rendered through ERB. Mount these files explicitly at the root with default routes in the generated routes file.

  _DHH_

- Updated system tests to now use headless Chrome by default for the new applications.

  _DHH_

- Add GitHub CI files for Dependabot, Brakeman, RuboCop, and running tests by default. Can be skipped with `--skip-ci`.

  _DHH_

- Add Brakeman by default for static analysis of security vulnerabilities. Allow skipping with `--skip-brakeman option`.

  _vipulnsward_

- Add RuboCop with rules from `rubocop-rails-omakase` by default. Skip with `--skip-rubocop`.

  _DHH_ and _zzak_

- Use `bin/rails runner --skip-executor` to not wrap the runner script with an
  Executor.

  _Ben Sheldon_

- Fix isolated engines to take `ActiveRecord::Base.table_name_prefix` into consideration.

  This will allow for engine defined models, such as inside Active Storage, to respect
  Active Record table name prefix configuration.

  _Chedli Bourguiba_

- Fix running `db:system:change` when the app has no Dockerfile.

  _Hartley McGuire_

- In Action Mailer previews, list inline attachments separately from normal
  attachments.

  For example, attachments that were previously listed like

  > Attachments: logo.png file1.pdf file2.pdf

  will now be listed like

  > Attachments: file1.pdf file2.pdf (Inline: logo.png)

  _Christian Schmidt_ and _Jonathan Hefner_

- In mailer preview, only show SMTP-To if it differs from the union of To, Cc and Bcc.

  _Christian Schmidt_

- Enable YJIT by default on new applications running Ruby 3.3+.

  This can be disabled by setting `Rails.application.config.yjit = false`

  _Jean Boussier_, _Rafael Mendonça França_

- In Action Mailer previews, show date from message `Date` header if present.

  _Sampat Badhe_

- Exit with non-zero status when the migration generator fails.

  _Katsuhiko YOSHIDA_

- Use numeric UID and GID in Dockerfile template.

  The Dockerfile generated by `rails new` sets the default user and group
  by name instead of UID:GID. This can cause the following error in Kubernetes:

  ```
  container has runAsNonRoot and image has non-numeric user (rails), cannot verify user is non-root
  ```

  This change sets default user and group by their numeric values.

  _Ivan Fedotov_

- Disallow invalid values for rails new options.

  The `--database`, `--asset-pipeline`, `--css`, and `--javascript` options
  for `rails new` take different arguments. This change validates them.

  _Tony Drake_, _Akhil G Krishnan_, _Petrik de Heus_

- Conditionally print `$stdout` when invoking `run_generator`.

  In an effort to improve the developer experience when debugging
  generator tests, we add the ability to conditionally print `$stdout`
  instead of capturing it.

  This allows for calls to `binding.irb` and `puts` work as expected.

  ```sh
  RAILS_LOG_TO_STDOUT=true ./bin/test test/generators/actions_test.rb
  ```

  _Steve Polito_

- Remove the option `config.public_file_server.enabled` from the generators
  for all environments, as the value is the same in all environments.

  _Adrian Hirt_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/railties/CHANGELOG.md) for previous changes.
