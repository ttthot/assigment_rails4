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

- Fix templates with strict locals to also include `local_assigns`.

  Previously templates defining strict locals wouldn't receive the `local_assigns`
  hash.

  _Jean Boussier_

- Add queries count to template rendering instrumentation.

  ```
  # Before
  Completed 200 OK in 3804ms (Views: 41.0ms | ActiveRecord: 33.5ms | Allocations: 112788)

  # After
  Completed 200 OK in 3804ms (Views: 41.0ms | ActiveRecord: 33.5ms (2 queries, 1 cached) | Allocations: 112788)
  ```

  _fatkodima_

- Raise `ArgumentError` if `:renderable` object does not respond to `#render_in`.

  _Sean Doyle_

- Add the `nonce: true` option for `stylesheet_link_tag` helper to support automatic nonce generation for Content Security Policy.

  Works the same way as `javascript_include_tag nonce: true` does.

  _Akhil G Krishnan_, _AJ Esler_

- Parse `ActionView::TestCase#rendered` HTML content as `Nokogiri::XML::DocumentFragment` instead of `Nokogiri::XML::Document`.

  _Sean Doyle_

- Rename `ActionView::TestCase::Behavior::Content` to `ActionView::TestCase::Behavior::RenderedViewContent`.

  Make `RenderedViewContent` inherit from `String`. Make private API with `:nodoc:`

  _Sean Doyle_

- Deprecate passing `nil` as value for the `model:` argument to the `form_with` method.

  _Collin Jilbert_

- Alias `field_set_tag` helper to `fieldset_tag` to match `<fieldset>` element.

  _Sean Doyle_

- Deprecate passing content to void elements when using `tag.br` type tag builders.

  _Hartley McGuire_

- Fix the `number_to_human_size` view helper to correctly work with negative numbers.

  _Earlopain_

- Automatically discard the implicit locals injected by collection rendering for template that can't accept them.

  When rendering a collection, two implicit variables are injected, which breaks templates with strict locals.

  Now they are only passed if the template will actually accept them.

  _Yasha Krasnou_, _Jean Boussier_

- Fix `@rails/ujs` calling `start()` an extra time when using bundlers.

  _Hartley McGuire_, _Ryunosuke Sato_

- Fix the `capture` view helper compatibility with HAML and Slim.

  When a blank string was captured in HAML or Slim (and possibly other template engines)
  it would instead return the entire buffer.

  _Jean Boussier_

- Updated `@rails/ujs` files to ignore certain data-\* attributes when element is contenteditable.

  This fix was already landed in >= 7.0.4.3, < 7.1.0.
  [[CVE-2023-23913](https://github.com/advisories/GHSA-xp5h-f8jf-rc8q)]

  _Ryunosuke Sato_

- Added validation for HTML tag names in the `tag` and `content_tag` helper method.

  The `tag` and `content_tag` method now checks that the provided tag name adheres to the HTML
  specification. If an invalid HTML tag name is provided, the method raises an `ArgumentError`
  with an appropriate error message.

  Examples:

  ```ruby
  # Raises ArgumentError: Invalid HTML5 tag name: 12p
  content_tag("12p") # Starting with a number

  # Raises ArgumentError: Invalid HTML5 tag name: ""
  content_tag("") # Empty tag name

  # Raises ArgumentError: Invalid HTML5 tag name: div/
  tag("div/") # Contains a solidus

  # Raises ArgumentError: Invalid HTML5 tag name: "image file"
  tag("image file") # Contains a space
  ```

  _Akhil G Krishnan_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/actionview/CHANGELOG.md) for previous changes.
