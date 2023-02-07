# Snyk Open Source rules for Bazel

![build status](https://github.com/scotte-snyk/bazel_rules_snyk/actions/workflows/build.yml/badge.svg)

Rules to test and monitor your open source (external) dependencies with Snyk

## OSS package support
* `maven` for projects using [rules_jvm_external](https://github.com/bazelbuild/rules_jvm_external)
* `go modules` for projects using [rules_go](https://github.com/bazelbuild/rules_go) in conjunction with [gazelle](https://github.com/bazelbuild/bazel-gazelle)

Currently investingating support for

- pip ([rules_python](https://github.com/bazelbuild/rules_python))
- npm ([rules_nodejs](https://github.com/bazelbuild/rules_nodejs), [rules_js](https://github.com/aspect-build/rules_js))

## Installation

Load the rules into your `WORKSPACE` to make them available

```python
load("@bazel_tools//tools/build_defs/repo:git.bzl", "git_repository")

git_repository(
    name = "rules_snyk",
    remote = "https://github.com/snyk-labs/rules_snyk.git",
    commit = "9b8593e",
)

load("@rules_snyk//:repositories.bzl", "rules_snyk_repos")
rules_snyk_repos()

load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "snyk_py_deps",
    requirements_lock = "@rules_snyk//third_party:requirements.txt",
)

load("@snyk_py_deps//:requirements.bzl", install_snyk_deps = "install_deps")
install_snyk_deps()
```

## Usage
### via `BUILD` file 

**Maven example**

```python
load("@rules_snyk//:defs.bzl", "snyk_maven")

snyk_maven(
    name = "snyk",
    target = ":lib",
    snyk_organization_id = "<snyk_org_id>"
)
```

**Go Modules example**

```python
load("@rules_snyk//:defs.bzl", "snyk_gomod")

snyk_gomod(
    name = "snyk",
    target = ":lib",
    snyk_organization_id = "{snyk_org_id}"
)
```


When the target is built, e.g.
```
bazel build :lib
```

Additional targets will automatically be created for Snyk
```
:snyk_test
:snyk_monitor
```

**Invocation**

environment variables:
- `SNYK_TOKEN` required to authenticate to Snyk
- `SNYK_ORG_ID` not required if specifying `snyk_organization_id` in the `BUILD` file

To test for issues with Snyk

```
bazel run :snyk_test
```

To monitor the target in Snyk

```
bazel run :snyk_monitor
```

### via `--aspect`

TBD
