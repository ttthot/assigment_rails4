## Rails 7.2.2.1 (December 10, 2024)

- Update vendored trix version to 2.1.10

  _John Hawthorn_

## Rails 7.2.2 (October 30, 2024)

- No changes.

## Rails 7.2.1.2 (October 23, 2024)

- No changes.

## Rails 7.2.1.1 (October 15, 2024)

- Avoid backtracing in plain_text_for_blockquote_node

  [CVE-2024-47888]

  _John Hawthorn_

## Rails 7.2.1 (August 22, 2024)

- Strip `content` attribute if the key is present but the value is empty

  _Jeremy Green_

## Rails 7.2.0 (August 09, 2024)

- Only sanitize `content` attribute when present in attachments.

  _Petrik de Heus_

- Sanitize ActionText HTML ContentAttachment in Trix edit view
  [CVE-2024-32464]

  _Aaron Patterson_, _Zack Deveau_

- Use `includes` instead of `eager_load` for `with_all_rich_text`.

  _Petrik de Heus_

- Delegate `ActionText::Content#deconstruct` to `Nokogiri::XML::DocumentFragment#elements`.

  ```ruby
  content = ActionText::Content.new <<~HTML
    <h1>Hello, world</h1>

    <div>The body</div>
  HTML

  content => [h1, div]

  assert_pattern { h1 => { content: "Hello, world" } }
  assert_pattern { div => { content: "The body" } }
  ```

  _Sean Doyle_

- Fix all Action Text database related models to respect
  `ActiveRecord::Base.table_name_prefix` configuration.

  _Chedli Bourguiba_

- Compile ESM package that can be used directly in the browser as actiontext.esm.js

  _Matias Grunberg_

- Fix using actiontext.js with Sprockets.

  _Matias Grunberg_

- Upgrade Trix to 2.0.7

  _Hartley McGuire_

- Fix using Trix with Sprockets.

  _Hartley McGuire_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/actiontext/CHANGELOG.md) for previous changes.
