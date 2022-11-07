load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")
load("@rules_snyk//:requirements.bzl", "install_deps")
#load("//tools/build/bazel/py_toolchain:py_interpreter.bzl", "python_build_standalone_interpreter")
#load("@rules_python//python:pip.bzl", "pip_parse")

def rules_snyk_dependencies():
    # python support for depgraph processing
    #http_archive(
    #    name = "rules_python",
    #    sha256 = "8c8fe44ef0a9afc256d1e75ad5f448bb59b81aba149b8958f02f7b3a98f5d9b4",
    #    strip_prefix = "rules_python-0.13.0",
    #    url = "https://github.com/bazelbuild/rules_python/archive/refs/tags/0.13.0.tar.gz",
    #)

    #python_build_standalone_interpreter(
    #    name = "python_interpreter",
    #)

    # Create a central repo that knows about the dependencies needed from
    # requirements.txt
    #pip_parse(
    #    name = "py_deps",
        #python_interpreter_target = "@python_interpreter//:python/install/bin/python3.9",
    #    requirements = "//third_party:requirements.txt",
    #)

    # Install from requirements.bzl
    install_deps()
