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

#load("//:dependencies.bzl", "rules_snyk_dependencies")

#rules_snyk_dependencies()

#python_build_standalone_interpreter(
        name = "python_interpreter",
    )
    
pip_install(
    name = "pypi_deps",
    python_interpreter_target = "@python_interpreter//:python/install/bin/python3.9",
    requirements = "//third_party:requirements.txt",
)

#load("@rules_snyk//tools/python:python_interpreter.bzl", "py_download")

#py_download(
#    name = "py_darwin_x86_64",
#    arch = "x86_64",
#    os = "darwin",
#    sha256 = "fc0d184feb6db61f410871d0660d2d560e0397c36d08b086dfe115264d1963f4",
#    urls = ["https://github.com/indygreg/python-build-standalone/releases/download/20211017/cpython-3.10.0-x86_64-apple-darwin-install_only-20211017T1616.tar.gz"],
#)

#py_download(
#    name = "py_linux_x86_64",
#    arch = "x86_64",
#    os = "linux",
#    sha256 = "eada875c9b39cc4bf4a055dd8f5188e99c0c90dd5deb05b6c213f49482fe20a6",
#    urls = ["https://github.com/indygreg/python-build-standalone/releases/download/20211017/cpython-3.10.0-x86_64-unknown-linux-gnu-install_only-20211017T1616.tar.gz"],
#)

#py_download(
#    name = "py_darwin_arm64",
#    arch = "arm64",
#    os = "darwin",
#    sha256 = "1409acd9a506e2d1d3b65c1488db4e40d8f19d09a7df099667c87a506f71c0ef",
#    urls = ["https://github.com/indygreg/python-build-standalone/releases/download/20220227/cpython-3.10.2+20220227-aarch64-apple-darwin-install_only.tar.gz"],
#)

#register_toolchains(
#    "@py_darwin_x86_64//:toolchain",
#    "@py_linux_x86_64//:toolchain",
#    "@py_darwin_arm64//:toolchain",
#)
