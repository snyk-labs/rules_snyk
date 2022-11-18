# Snyk Open Source rules for Bazel

![build status](https://github.com/scotte-snyk/bazel_rules_snyk/actions/workflows/build.yml/badge.svg)

Rules to test and monitor your open source (external) dependencies with Snyk

## Overview
Current support is limited to maven OSS for projects using `rules_jvm_external`

Support for additional OSS types is forthcoming, in order of priority:

- go modules (rules_go)
- pip (rules_python)
- npm (rules_nodejs)
- others in order of priority

## Installation

Load the rules into your `WORKSPACE` to make them available

```
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_snyk",
    remote = "https://github.com/scotte-snyk/bazel_rules_snyk.git",
    commit = "3a131bc16a8a735cf2d8b331e0b7e94a5d91f7e5",
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
    target = ":lib",
    snyk_organization_id = "<snyk_org_id>"
)
```

snyk_maven is a macro, such that when the target is built, e.g.
```
bazel build :lib
```

Additional targets will automatically be created for Snyk .  In this example, those would be 
```
:snyk_test
:snyk_monitor
```

**Invocation**

environment variables:
- `SNYK_TOKEN` required to authenticate to Snyk
- `SNYK_ORG_ID` not required if specifying `snyk_organization_id` in the `BUILD` file

To test for issues with Snyk, simply run

`bazel run :snyk_test`

To monitor the target in Snyk, simply run

`bazel run :snyk_monitor`

### via `--aspect`

TBD
