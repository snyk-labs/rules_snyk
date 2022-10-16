"""Our "development" dependencies

Users should *not* need to install these. If users see a load()
statement from these, that's a bug in our distribution.
"""

load("@bazel_tools//tools/build_defs/repo:http.bzl", _http_archive = "http_archive")
load("@bazel_tools//tools/build_defs/repo:utils.bzl", "maybe")

def http_archive(name, **kwargs):
    maybe(_http_archive, name = name, **kwargs)

def rules_snyk_internal_deps():
    "Fetch deps needed for local development"
    #http_archive(
    #    name = "build_bazel_integration_testing",
    #    urls = [
    #        "https://github.com/bazelbuild/bazel-integration-testing/archive/165440b2dbda885f8d1ccb8d0f417e6cf8c54f17.zip",
    #    ],
    #    strip_prefix = "bazel-integration-testing-165440b2dbda885f8d1ccb8d0f417e6cf8c54f17",
    #    sha256 = "2401b1369ef44cc42f91dc94443ef491208dbd06da1e1e10b702d8c189f098e3",
    #)

