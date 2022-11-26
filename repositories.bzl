load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

def rules_snyk_repos():
    # python support for depgraph processing
    http_archive(
        name = "rules_python",
        sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
        strip_prefix = "rules_python-0.13.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
    )
    #http_archive(
    #    name = "rules_python",
    #    sha256 = "a868059c8c6dd6ad45a205cca04084c652cfe1852e6df2d5aca036f6e5438380",
    #    strip_prefix = "rules_python-0.14.0",
    #    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.14.0.tar.gz",
    #)
