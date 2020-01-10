## 1.2.2

- fixes a bug where pubx would fail if no author or authors field was present
  in a pubspec

## 1.2.1

- fixes a bug where pubx would throw an exception in the absence of
  an existing dependencies/dev_dependencies map

## 1.2.0

- add a `which` command, for finding the path of packages locally
- the `add` command now works from sub-folders

## 1.1.1

- fix bug introduced in 1.1.0, where updating a dependency with an unspecified
  version would output invalid yaml

## 1.1.0

- add command will now replace existing version constraints if dependency is
  already present
- add command no longer inserts duplicates

I realize that I should have bumped minor with the last release, but neglected
to.

## 1.0.8

- The add command (courtesy of @Vanethos), for adding a dependency to
  pubspec.yaml
- A bug fix in HTTP status code evaluation (courtesy of @f3ath)

## 1.0.7

Courtesy of @Vanethos:
- Support for pubspec.yaml's authors field
- Suppressing of stack trace when command is not understood

## 1.0.6

- Added the --version-only flag to `pubx view`

## 1.0.5

- Even _better_ description. :)

## 1.0.4

- Improves package description, and adds an example

## 1.0.3

- Adds a --versions flag for view

## 1.0.0

- Initial version, created by Stagehand
