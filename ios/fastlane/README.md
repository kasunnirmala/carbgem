fastlane documentation
----

# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```sh
xcode-select --install
```

For _fastlane_ installation instructions, see [Installing _fastlane_](https://docs.fastlane.tools/#installing-fastlane)

# Available Actions

## iOS

### ios build_number

```sh
[bundle exec] fastlane ios build_number
```

Test version number and build number

### ios closed_beta

```sh
[bundle exec] fastlane ios closed_beta
```

Push a new beta build to TestFlight

### ios staging_closed_beta

```sh
[bundle exec] fastlane ios staging_closed_beta
```

Push a new beta build to TestFlight for staging env (carbgem-bitte-test)

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.

More information about _fastlane_ can be found on [fastlane.tools](https://fastlane.tools).

The documentation of _fastlane_ can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
