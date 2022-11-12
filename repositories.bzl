load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
#load("//:py_requirements.bzl", install_vendored_deps = "install_deps")


def rules_snyk_repos():
    # python support for depgraph processing
    http_archive(
        name = "rules_python",
        sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
        strip_prefix = "rules_python-0.13.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
    )

    # Create a central repo that knows about the dependencies needed from
    # requirements.txt
    #pip_parse(
    #    name = "py_deps",
    #    requirements = "//third_party:requirements.txt",
    #)

    #install_deps()

    # Install vendored from py_requirements.bzl (for downstream workspaces)
    #install_vendored_deps()
