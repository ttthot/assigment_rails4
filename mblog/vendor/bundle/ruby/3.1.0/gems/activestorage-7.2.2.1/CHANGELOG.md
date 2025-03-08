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

- Remove deprecated `config.active_storage.silence_invalid_content_types_warning`.

  _Rafael Mendonça França_

- Remove deprecated `config.active_storage.replace_on_assign_to_many`.

  _Rafael Mendonça França_

- Add support for custom `key` in `ActiveStorage::Blob#compose`.

  _Elvin Efendiev_

- Add `image/webp` to `config.active_storage.web_image_content_types` when `load_defaults "7.2"`
  is set.

  _Lewis Buckley_

- Fix JSON-encoding of `ActiveStorage::Filename` instances.

  _Jonathan del Strother_

- Fix N+1 query when fetching preview images for non-image assets.

  _Aaron Patterson & Justin Searls_

- Fix all Active Storage database related models to respect
  `ActiveRecord::Base.table_name_prefix` configuration.

  _Chedli Bourguiba_

- Fix `ActiveStorage::Representations::ProxyController` not returning the proper
  preview image variant for previewable files.

  _Chedli Bourguiba_

- Fix `ActiveStorage::Representations::ProxyController` to proxy untracked
  variants.

  _Chedli Bourguiba_

- When using the `preprocessed: true` option, avoid enqueuing transform jobs
  for blobs that are not representable.

  _Chedli Bourguiba_

- Prevent `ActiveStorage::Blob#preview` to generate a variant if an empty variation is passed.

  Calls to `#url`, `#key` or `#download` will now use the original preview
  image instead of generating a variant with the exact same dimensions.

  _Chedli Bourguiba_

- Process preview image variant when calling `ActiveStorage::Preview#processed`.

  For example, `attached_pdf.preview(:thumb).processed` will now immediately
  generate the full-sized preview image and the `:thumb` variant of it.
  Previously, the `:thumb` variant would not be generated until a further call
  to e.g. `processed.url`.

  _Chedli Bourguiba_ and _Jonathan Hefner_

- Prevent `ActiveRecord::StrictLoadingViolationError` when strict loading is
  enabled and the variant of an Active Storage preview has already been
  processed (for example, by calling `ActiveStorage::Preview#url`).

  _Jonathan Hefner_

- Fix `preprocessed: true` option for named variants of previewable files.

  _Nico Wenterodt_

- Allow accepting `service` as a proc as well in `has_one_attached` and `has_many_attached`.

  _Yogesh Khater_

Please check [7-1-stable](https://github.com/rails/rails/blob/7-1-stable/activestorage/CHANGELOG.md) for previous changes.
