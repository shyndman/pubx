# pubx

The missing `pub` commands.

Search and view packages from pub.dev from the command line.

## Installation & Usage

```sh
pub global activate pubx
pubx search json
```

## Commands

### search

*Aliases: se, s, find*

Searches [pub.dev](https://pub.dev).

`pubx search {query}`

### view

*Aliases: info, show, v*

Displays information about the specified package.

`pubx view {package-name}`

### add

*Aliases: a*

Adds the package to your `pubspec.yaml` file.

`pubx add {package-name}`

Additional options:

* `dev` - add this as a `dev_dependencies`
* `lock` - lock the version using the `^` symbol
