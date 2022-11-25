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

load("//:repositories.bzl", "rules_snyk_repos")
rules_snyk_repos()

# Create a central repo that knows about the dependencies needed from
# requirements.txt
load("@rules_python//python:pip.bzl", "pip_parse")

pip_parse(
    name = "py_deps",
    requirements = "//third_party:requirements.txt",
)

load("@py_deps//:requirements.bzl", install_snyk_deps = "install_deps")
install_snyk_deps()

load("//:dependencies.bzl", "rules_snyk_deps")
rules_snyk_deps()

