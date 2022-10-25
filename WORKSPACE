# Declare the local Bazel workspace.
workspace(
    # If your ruleset is "official"
    # (i.e. is in the bazelbuild GitHub org)
    # then this should just be named "rules_snyk"
    # see https://docs.bazel.build/versions/main/skylark/deploying.html#workspace
    name = "rules_snyk",
)

local_repository(
    name = "rules_snyk",
    path = ".",
)

load("//:internal_deps.bzl", "rules_snyk_internal_deps")
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

# python support for depgraph processing
rules_python_version = "740825b7f74930c62f44af95c9a4c1bd428d2c53" # Latest @ 2021-06-23

http_archive(
    name = "rules_python",
    sha256 = "3474c5815da4cb003ff22811a36a11894927eda1c2e64bf2dac63e914bfdf30f",
    strip_prefix = "rules_python-{}".format(rules_python_version),
    url = "https://github.com/bazelbuild/rules_python/archive/{}.zip".format(rules_python_version),
)
