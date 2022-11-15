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

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_snyk",
    remote = "https://github.com/scotte-snyk/bazel_rules_snyk.git",
    commit = "3bb81ba4464fff56daa130348f427ec87201b65f",
)

load("@rules_snyk//:repositories.bzl", "rules_snyk_repos")
rules_snyk_repos()

load("@rules_snyk//:dependencies.bzl", "rules_snyk_deps")
rules_snyk_deps()
```

## Usage
### via `BUILD` file 

**Maven example**

```
load("@rules_snyk//:defs.bzl", "snyk_maven")

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

**Invocation**

To test for issues with Snyk, simply run

`bazel run :lib.snyk_test`

To monitor the target in Snyk, simply run

`bazel run :lib.snyk_monitor`

### via `--aspect`
