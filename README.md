# Snyk Open Source rules for Bazel

Rules to test and monitor your open source dependencies with Snyk

## Overview
Current support is limited to maven OSS for projects using `rules_jvm_external`

Support for additional OSS types is forthcoming, in order of priority:

- go modules (rules_go)
- pip (rules_python)
- npm (rules_nodejs)

## Installation

Load the rules into your `WORKSPACE` to make them available

## Usage
### via `BUILD` file 

*Maven example*

```
load("@rules_snyk//snyk/defs.bzl", "snyk_maven")

snyk_maven(
    name = "snyk",
    target = ":lib"
)
```

snyk_maven is a macro, such that when the target is built, e.g.
```
bazel build :lib
```

Additional targets will automatically be created for Snyk .  In this example, those would be 
```
:lib.snyk_test
:lib.snyk_monitor
```

To test for issues with Snyk, simply run

`bazel run :lib.snyk_test`

To monitor the target in Snyk, simply run

`bazel run :lib.snyk_monitor`

### via `--aspect`
