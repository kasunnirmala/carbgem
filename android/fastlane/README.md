fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## Android

### android test

```sh
[bundle exec] fastlane android test
```

Runs all the tests

### android increment_vc

```sh
[bundle exec] fastlane android increment_vc
```

Manage version code

### android demo

```sh
[bundle exec] fastlane android demo
```

build demo

### android stg_build

```sh
[bundle exec] fastlane android stg_build
```

build Staging

### android deploy

```sh
[bundle exec] fastlane android deploy
```

Deploy a new version to the Google Play

### android staging_deploy

```sh
[bundle exec] fastlane android staging_deploy
```

(STAGING) Deploy a new version to the Google Play

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
