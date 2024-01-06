load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive", "http_file")

def rules_snyk_repos():
    # python support for depgraph processing
    http_archive(
        name = "rules_python",
        sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
        strip_prefix = "rules_python-0.13.0",
        url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
    )
    http_archive(
        name = "io_bazel_rules_go",
        sha256 = "099a9fb96a376ccbbb7d291ed4ecbdfd42f6bc822ab77ae6f1b5cb9e914e94fa",
        urls = [
            "https://mirror.bazel.build/github.com/bazelbuild/rules_go/releases/download/v0.35.0/rules_go-v0.35.0.zip",
            "https://github.com/bazelbuild/rules_go/releases/download/v0.35.0/rules_go-v0.35.0.zip",
        ],
    )
    #http_archive(
    #    name = "rules_python",
    #    sha256 = "a868059c8c6dd6ad45a205cca04084c652cfe1852e6df2d5aca036f6e5438380",
    #    strip_prefix = "rules_python-0.14.0",
    #    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.14.0.tar.gz",
    #)
    http_file(
        name = "snyk_cli",
        url = "https://github.com/snyk/cli/releases/download/v1.1256.0/snyk-macos-arm64",
        sha256 = "346a52114f682f176536740e9e972758e2bfd678c7e8da30bb99058e19afb276",
    )
