# pubx

The missing `pub` commands.

Search and view packages from pub.dev from the command line.

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

*Aliases: updates, u*

Checks pub.dev for packages in your pubspec that have updated versions

`pubx updates`

### view

*Aliases: info, show, v*

Displays information about the specified package.

`pubx view {package-name}`
