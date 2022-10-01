Tools to make Solus packaging even easier.

[![License](https://img.shields.io/badge/License-Apache%202.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

## Features

- [ ] Remove all packages from the local solbuild repo.
- [x] Copy eopkg files from current directory to the default local repo.
- [x] Index the local repo
- [ ] Initialize a new package repo

## Installation

To build `soltools-d`, you'll need a D compiler, meson, and Dub.

Once you have those, configure and build with:

```bash
meson --prefix=%PREFIX% build
ninja -C build
```

Then, install it with:

```bash
sudo ninja install -C build
```

## Usage

`soltools-d subcommand [OPTIONS]`

Running just `soltools-d` will print the usage information.

## License

Copyright &copy; 2022 Evan Maddock maddock.evan@vivaldi.net

`soltools-d` is available under the terms of the Apache 2.0 license.
