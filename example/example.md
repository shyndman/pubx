# Example
## Installation
```sh
pub global activate pubx
```

## pubx search: Search packages
*Aliases: se, s, find*

```sh
pubx search json
```

## pubx view: View package information
*Aliases: info, show, v*

```sh
pubx view mobx
```

#### Show package versions
```sh
pubx view built_value --versions
```

#### Print version only
```sh
pubx view built_value --version-only

# Useful for easy copying to the clipboard
pubx view provider --version-only | pbcopy
```
