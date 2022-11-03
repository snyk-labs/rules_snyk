load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")


def rules_snyk_dependencies():
    # python support for depgraph processing
    http_archive(
        name = "rules_python",
        sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
        strip_prefix = "rules_python-0.13.0",
    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
)

    #def rules_snyk_dependencies():
        # rules_nodejs is required for installing and running the Snyk CLI
    #    http_archive(
    #        name = "build_bazel_rules_nodejs",
    #        sha256 = "3aa6296f453ddc784e1377e0811a59e1e6807da364f44b27856e34f5042043fe",
    #        urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.4.2/rules_nodejs-4.4.2.tar.gz"],
    #   )

    #    http_archive(
    #        name = "io_bazel_rules_go",
    #        sha256 = "2b1641428dff9018f9e85c0384f03ec6c10660d935b750e3fa1492a281a53b0f",
    #        urls = [
    #            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
    #            "https://github.com/bazelbuild/rules_go/releases/download/v0.29.0/rules_go-v0.29.0.zip",
    #        ],
    #    )
