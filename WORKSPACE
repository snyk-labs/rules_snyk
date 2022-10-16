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

