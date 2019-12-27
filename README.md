# pubx

The missing `pub` commands.

Search and view [pub.dev](https://pub.dev) packages from the command line.

## Installation & Usage

```sh
pub global activate pubx
pubx search json
```

## Commands

### add

*Alias: a*

Adds the package to your `pubspec.yaml` file.

`pubx add {package-name}`

Additional options:

* `dev` - add this as a `dev_dependencies` entry
* `lock` - omits the `^` symbol to lock to the latest version

### search

*Aliases: se, s, find*

Searches [pub.dev](https://pub.dev).

`pubx search {query}`

### view

*Aliases: info, show, v*

Displays information about the specified package.

`pubx view {package-name}`
